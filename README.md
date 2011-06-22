# 'Customfield basename modification SQL error bug' patch plugin for Movable Type Pro/Commercial/Community pack 4.3x #

This plugin implements a patch for Movable Type v4.3x installations running Custom Fields to resolve a bug in which a SQL error will be throw if a custom field is saved using a modified basename.  This can also happen when Theme Manager is used to apply a theme including custom fields.

## INSTALLATION ##

### Prerequisites ###

* Movable Type v4.3x with Custom Fields

### Download ###

The latest version of the plugin can be downloaded from the its
[Github repo][]. [Packaged downloads][] are also available if you prefer.

After downloading and unpacking the distribution archive, you will likely have
a directory called `mt-patch-user-profile-cf` containing the plugin's
`config.yaml` file, `lib` and `extlib` directories and a copy of this
`README`.

To install the plugin, simply move this directory to your MT installation's `plugins` directory.

[Github repo]: https://github.com/endevver/mt-patch-cf-save-sql-error
[Packaged downloads]:
 https://github.com/endevver/mt-patch-cf-save-sql-error/downloads

## CONFIGURATION ##

Upon installation, the plugin must be configured properly in order to be
activated. This is done by adding the following line to your `mt-config.cgi`
(replacing 4.35 with your current version of MT if it differs):

    CFBasenameModPatchEnabled 4.35

This activates the plugin for the specified version of Movable Type
***only***. Upon upgrade or removal of that line, the plugin resets to an
inactive state. 

This **explicit, release-specific activation** ensures that the
patch is not active after an upgrade in which the issue is finally resolved.

## USAGE ##

Once the plugin is in place and properly configured for the current version of
Movable Type, there's really nothing more to do. However, you can test that
it's working by doing the following:

   1. Go to the custom field listing screen
   2. Click on a custom field to get to its editing screen
   3. Change the basename of the field and save.
   4. If you don't see an immediate error, check for it in the activity log.
      If no error, then its working.

If you're using Theme Manager and you have a theme which defines custom fields, you can also test it by re-applying the theme to a blog.  It should succeed with no error in the Activity log.

After doing one of the above, remove or disable the plugin and restart your webserver if running under FastCGI.  Performing the above should log the error in your Activity log.

Next, you can simulate an upgrade by decrementing your
`CFBasenameModPatchEnabled` value to the last version or any previous version
of Movable Type:

    CFBasenameModPatchEnabled 4.0

Upon doing this, the plugin is rendered inactive and the bug will be
re-appear. Eventually, when the Movable Type team fixes this issue, the bug
will stay fixed even after an upgrade. At that point, you're free to remove
the plugin and the configuration directive although since it's disabled by
each upgrade there's no harm done if it's there.

<!--
-----------------------------------------------------------------------------
-->


## KNOWN ISSUES AND LIMITATIONS ##

None.

<!--
-----------------------------------------------------------------------------
-->

## SUPPORT, BUGS AND FEATURE REQUESTS ##

Please see <http://help.endevver.com/> for all of the above.

<!--
-----------------------------------------------------------------------------
-->

## LICENSE ##

This program is distributed under the terms of the GNU General Public License,
version 2.

<!--
-----------------------------------------------------------------------------
-->

## COPYRIGHT ##

Copyright 2011, [Endevver LLC](http://endevver.com). All rights reserved.

