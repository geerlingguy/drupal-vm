Drupal VM defaults to PHP 7, but you can install and use 5.6 if you need to maximize compatibility with older Drupal 6 and 7 sites.

## Ubuntu 16.04

Ubuntu 16.04 Xenial defaults to PHP 7.0 in it's system packages. No older versions of PHP will be supported if using this base box.

## Ubuntu 14.04 / Ubuntu 12.04

Ondřej Surý's PPA is used to install PHP 7, but you can switch to using 5.6 by changing `php_version` inside `config.yml` to `"5.6"`

If you're using Apache with `mod_php` you should also add `libapache2-mod-php5.6` to the `extra_packages` list.

## RedHat/CentOS 7

Remi's RPM repository is included with Drupal VM, and to install PHP 5.6 instead of 7 you can changing `php_version` inside `config.yml` to `"5.6"`
