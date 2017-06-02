[XDebug](https://xdebug.org/) is a useful tool for debugging PHP applications, but it uses extra memory and CPU for every request, so is disabled by default.

To enable XDebug, do the following in `config.yml`:

  - Change `php_xdebug_default_enable` (and, optionally, `php_xdebug_coverage_enable` to get code coverage reports) to `1`
  - Make sure `xdebug` is in the list of `installed_extras`

If you don't need to use XDebug, you can comment it out or remove it from `installed_extras` before you `vagrant up` Drupal VM.

### PHPStorm and XDebug with Drupal VM

To use XDebug with PHPStorm, change the `php_xdebug_idekey` variable as shown below in `config.yml`, and then run `vagrant provision` to reconfigure the VM:

```yaml
php_xdebug_idekey: PHPSTORM
```

### Sublime Text and XDebug with Drupal VM

To use XDebug with Sublime Text, change the `php_xdebug_idekey` variable as shown below in `config.yml`, and then run `vagrant provision` to reconfigure the VM:

```yaml
php_xdebug_idekey: sublime.xdebug
```

To configure a Sublime Text project to use XDebug when debugging, add the following `settings` key to your project's `.sublime-project` file:

```json
 "settings": {
   "xdebug": {
     "path_mapping": {
       "/var/www/projectname/docroot" : "/Users/geerlingguy/Sites/projectname/docroot",
     },
     "url": "http://local.projectname.com/",
     "super_globals": true,
     "close_on_stop": true
   }
 }
```

This assumes you have already installed [SublimeTextXdebug](https://github.com/martomo/SublimeTextXdebug) via Package Control.

### NetBeans and XDebug with Drupal VM

To use XDebug with NetBeans, change the `php_xdebug_idekey` variable as shown below in `config.yml`, and then run `vagrant provision` to reconfigure the VM.

```yaml
php_xdebug_idekey: netbeans-xdebug
```

### XDebug over SSH/Drush

As long as `xdebug` is listed in `installed_extras` Drupal VM is configured to accept the `PHP_IDE_CONFIG`, `XDEBUG_CONFIG` and `PHP_OPTIONS` environment variables over SSH and this can be used to set up some IDE's as well as enable XDebug on a per request basis:

```
PHP_OPTIONS="-d xdebug.default_enable=1" drush @drupalvm.drupalvm.dev migrate-import
```

To send the environment variables when using `vagrant ssh`, [create a `Vagrantfile.local`](../extending/vagrantfile.md) with:

```
config.ssh.forward_env = ['PHP_IDE_CONFIG', 'XDEBUG_CONFIG', 'PHP_OPTIONS']
```

And you can run:

```
XDEBUG_CONFIG="-d default_enable=1" vagrant ssh -c 'php /var/www/drupalvm/drupal/web/core/scripts/run-tests.sh --url http://drupalvm.dev --all'
XDEBUG_CONFIG="-d default_enable=1" vagrant ssh -c 'cd /var/www/drupalvm/drupal/web/core; php ../../vendor/bin/phpunit tests/Drupal/Tests/Core/Password/PasswordHashingTest.php'
```

## Profiling code with XDebug

While most people use XDebug only for debugging purposes, you can also use it for profiling. It's not as commonly used for profiling as either Blackfire or XHProf, but it works!

**Note**: You should only enable one code profiler at a time—e.g. when using [Blackfire](blackfire.md), disable [XHProf](xhprof.md), [Tideways](tideways.md) and [XDebug](xdebug.md).

For a list of available role variables, see the [`geerlingguy.php-xdebug` Ansible role's README](https://github.com/geerlingguy/ansible-role-php-xdebug#readme).
