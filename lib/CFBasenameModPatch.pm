package CFBasenameModPatch;

use strict;
use warnings;
use base qw( MT::Object );

sub post_init {
    my ( $cb, $mt, $logger ) = @_;

    # Melody doesn't have this problem...
    return if $mt->product_code eq 'OM';

    # Check that CFBasenameModPatchEnabled config value matches
    # the current MT version. This ensures that the plugin is disabled
    # initially by default and is always automatically disabled upon
    # upgrade unless the sysadmin updates the config to the new version
    # number to re-enable it until next upgrade.
    if ( my $enabled_for_version = $mt->config->CFBasenameModPatchEnabled ) {
        return unless $enabled_for_version
                  and $enabled_for_version == $mt->version_number;
        
        require Sub::Install;
        Sub::Install::reinstall_sub({
                                       code => 'save_patched',
                                       from => __PACKAGE__,
                                       into => 'CustomFields::Field',
                                       as   => 'save'
                                     });
    }
}

sub save_patched {
    my $field = shift;

    ## If there's no basename specified, create a unique basename.
    if (!defined($field->basename) || ($field->basename eq '')) {
        my $name = $field->make_unique_field_basename();
        $field->basename($name);
    }

    my $id = $field->id;
    my $orig_basename;

    if ($id) {
        if ($field->{changed_cols}{basename}) {
            my $orig_obj = CustomFields::Field->load($id);
            $orig_basename = $orig_obj->basename;
        }
    }

    my $res = $field->SUPER::save(@_);
    if ($res) {
        if (! $id) { # new meta field
            # install it!
            $field->add_meta();
        }
        if ( defined $orig_basename ) {
            # update existing meta records to use new basename
            my $ppkg = MT->model($field->obj_type);
            if ($ppkg) {
                if (my $mpkg = $ppkg->meta_pkg) {
                    my $driver = $mpkg->driver;
                    my $type_col = $driver->dbd->db_column_name($mpkg->datasource, 'type');
                    my $dbh = $driver->r_handle;
                    if ( $field->basename ne $orig_basename ) {
                        my $basename = $field->basename;
                        $orig_basename = $orig_basename;

                        $driver->sql('update ' . $mpkg->table_name
                            . qq{ set $type_col='field.$basename'}
                            . qq{ where $type_col='field.$orig_basename'});

                        $driver->clear_cache if $driver->can('clear_cache');
                    }
                }
            }
        }
    }

    return $res;
}

1;