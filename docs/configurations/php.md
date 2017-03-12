Drupal VM defaults to PHP 7.0, but you can also install and use 5.6 or 7.1.

## Ubuntu

Ondřej Surý's PPA for PHP is used to install PHP 7.0, but you can switch to using 5.6 or 7.1 packages by changing `php_version` inside `config.yml` to `"5.6"` or `"7.1"`.

If you're using Apache with `mod_php` you should also add `libapache2-mod-php5.6` or `libapache2-mod-php7.1` to the `extra_packages` list.

_Note: XHProf does currently not work with PHP 7.1, make sure you don't have it listed in `installed_extras`._

## RedHat/CentOS 7

Remi's RPM repository is included with Drupal VM, and you can make the following changes to use it to install PHP 7.1 or PHP 5.6 instead of 7.0:

  1. Make sure you've followed the directions for switching to CentOS 7 in the [use a different base OS](base-os.md) guide.
  2. Change `php_version` inside `config.yml` to `"5.6"` or `"7.1"`.
