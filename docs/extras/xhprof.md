As a prerequisite, make sure you have `xhprof` in the `installed_extras` list inside `config.yml` (So the PHP XHProf extension is installed on Drupal VM).

**Note**: You should disable `xdebug` when enabling/using XHProf, because it is known to have issues running alongside XHProf, and makes test results less reliable and slower than they should be.

## XHProf module

The easiest way to use XHProf to profile your PHP code on a Drupal site is to install the [XHProf](https://www.drupal.org/project/xhprof) module, then in XHProf's configuration (at `/admin/config/development/xhprof`), check the 'Enable profiling of page views and drush requests' checkbox.

The XHProf module doesn't yet include support for callgraphs, but there's an issue to [add callgraph support](https://www.drupal.org/node/1470740).

## Devel module (deprecated)

The Devel module also *used* to provide XHProf configuration, and setting the options below would allow Devel's XHProf integration to work correctly with Drupal VM's XHProf installation:

  - **xhprof directory**: `/usr/share/php`
  - **XHProf URL**: `http://xhprof.drupalvm.dev` (assuming this domain is configured in `apache_vhosts` inside `config.yml`)
