XDebug can be a useful tool for debugging PHP applications, but it uses extra memory and CPU for every request, therefore it's disabled by default. To enable XDebug, change the `php_xdebug_default_enable` and `php_xdebug_coverage_enable` to `1` in your `config.yml`, and make sure `xdebug` is in the list of `installed_extras`.

If you don't need to use XDebug, you can remove it from the list of `installed_extras` entirely, before you `vagrant up` Drupal VM.

## PHPStorm and XDebug with Drupal VM

TODO.

## Sublime Text and XDebug with Drupal VM

TODO.