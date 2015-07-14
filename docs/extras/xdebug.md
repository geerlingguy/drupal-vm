XDebug is a useful tool for debugging PHP applications, but it uses extra memory and CPU for every request, so is disabled by default.

To enable XDebug, do the following in `config.yml`:

  - Change `php_xdebug_default_enable` (and, optionally, `php_xdebug_coverage_enable` to get code coverage reports) to `1`
  - Make sure `xdebug` is in the list of `installed_extras`

If you don't need to use XDebug, you can comment it out or remove it from `installed_extras` before you `vagrant up` Drupal VM.

## PHPStorm and XDebug with Drupal VM

To use XDebug with PHPStorm, change the `php_xdebug_idekey` variable as shown below in `config.yml`, and then run `vagrant provision` to reconfigure the VM:

```yaml
php_xdebug_idekey: PHPSTORM
```

## Sublime Text and XDebug with Drupal VM

To use XDebug with Sublime Text, change the `php_xdebug_idekey` variable as shown below in `config.yml`, and then run `vagrant provision` to reconfigure the VM:

```yaml
php_xdebug_idekey: sublime.xdebug
```
