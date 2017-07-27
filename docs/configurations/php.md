Drupal VM defaults to PHP 7.1, but you can also install and use 5.6 or 7.0.

## Ubuntu

Ondřej Surý's PPA for PHP is used to install PHP 7.1, but you can switch to using 5.6 or 7.0 packages by changing `php_version` inside `config.yml` to `"5.6"` or `"7.0"`.

If you're using Apache with `mod_php` you should also add `libapache2-mod-php5.6` or `libapache2-mod-php7.0` to the `extra_packages` list.

_Note: XHProf does currently not work with PHP 7.1, make sure you don't have it listed in `installed_extras`._

## RedHat/CentOS 7

Remi's RPM repository is included with Drupal VM, and you can make the following changes to use it to install PHP 7.0 or PHP 5.6 instead of 7.1:

  1. Make sure you've followed the directions for switching to CentOS 7 in the [use a different base OS](base-os.md) guide.
  2. Change `php_version` inside `config.yml` to `"5.6"` or `"7.0"`.

## Using default distribution packages

If you want parity with your production environment and wish to install the default distribution packages, set `php_version: ''` inside your `config.yml` to avoid adding Remi's or Ondřej's repositories. Doing this will use the default packages set in the [`geerlingguy.php`](https://github.com/geerlingguy/ansible-role-php) Ansible role.

_Note: If you're using a base OS with a PHP version older than what's assumed in the `geerlingguy.php` role, you will also need to override some of the default variables set by that role in your `config.yml`. See the [`geerlingguy.php` Ansible role's README](https://github.com/geerlingguy/ansible-role-php-#readme) for more information._
