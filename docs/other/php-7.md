Drupal VM fully supports PHP 7, but currently defaults to 5.6 in order to maximize compatibility with older Drupal 6 and 7 sites. Soon, Drupal VM will change its defaults to install PHP 7.x instead of 5.x, but until then, follow the instructions below to use PHP 7.

_Note: If you have Ansible installed on your host machine, make sure you're running the latest version of all Ansible role dependencies by running `ansible-galaxy install -r provisioning/requirements.txt --force` inside the root Drupal VM project folder._

## Ubuntu 14.04

Ondřej Surý's PPA for PHP 7.0 is included with Drupal VM, and you can make the following changes/additions to `config.yml` to use it:

```yaml
php_version: "7.0"
php_packages:
  - libapache2-mod-php7.0
  - php7.0-common
  - php7.0-cli
  - php7.0-dev
  - php7.0-fpm
  - libpcre3-dev
  - php-gd
  - php-curl
  - php-imap
  - php-json
  - php-opcache
php_mysql_package: php-mysql
php_fpm_daemon: php7.0-fpm
```

Also, comment out `memcached` from the `installed_extras` list, as the PHP Memcached extension is not yet available for PHP 7 (as of late 2015).

You can also build from source using the same/included `geerlingguy.php` Ansible role, but that process is a bit more involved and for power users comfortable with the process.

## RedHat/CentOS 7

Remi's RPM repository is included with Drupal VM, and you can make the following changes to use it to install PHP 7:

  1. Make sure you've followed the directions for switching to CentOS 7 in the [use a different base OS](https://github.com/geerlingguy/drupal-vm/wiki/Using-Different-Base-OSes) guide.
  2. Change `php_version` inside `config.yml` to `"7.0"`.
  3. Comment `xhprof`, `xdebug`, and `memcached` from the `installed_extras` in `config.yml`, as they're not yet supported.
