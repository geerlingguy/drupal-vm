Drupal VM defaults to PHP 7, but you can install and use 5.6 if you need to maximize compatibility with older Drupal 6 and 7 sites.

## Ubuntu 16.04

Ubuntu 16.04 Xenial defaults to PHP 7.0 in it's system packages. No older versions of PHP will be supported if using this base box.

## Ubuntu 14.04 / Ubuntu 12.04

Ondřej Surý's PPA for PHP 7.0 is used to install PHP 7, but you can switch to using different 5.6 packages instead by making the following changes to `config.yml`:

```yaml
vagrant_box: geerlingguy/ubuntu1404
php_version: "5.6"
php_install_recommends: no
php_packages:
  - php5.6
  - php5.6-apcu
  - php5.6-mcrypt
  - php5.6-cli
  - php5.6-common
  - php5.6-curl
  - php5.6-dev
  - php5.6-fpm
  - php5.6-gd
  - php5.6-sqlite3
  - php5.6-xml
  - php5.6-mbstring
  - libpcre3-dev
php_conf_paths:
  - /etc/php/5.6/fpm
  - /etc/php/5.6/apache2
  - /etc/php/5.6/cli
php_extension_conf_paths:
  - /etc/php/5.6/fpm/conf.d
  - /etc/php/5.6/apache2/conf.d
  - /etc/php/5.6/cli/conf.d
php_fpm_daemon: php5.6-fpm
php_fpm_conf_path: "/etc/php/5.6/fpm"
php_fpm_pool_conf_path: "/etc/php/5.6/fpm/pool.d/www.conf"
php_mysql_package: php5.6-mysql
```

If you're using Apache with `mod_php` you should also add `libapache2-mod-php5.6` to the `php_packages` list.

Also, if you're using one of the `installed_extras`, you may need to update the package names accordingly:

```yaml
# If you install `redis`:
php_redis_package: php5.6-redis

# If you install `memcached`:
php_memcached_package: php5.6-memcached

# If you install `xhprof`:
xhprof_download_url: https://github.com/phacility/xhprof/archive/master.tar.gz
xhprof_download_folder_name: xhprof-master
```

## RedHat/CentOS 7

Remi's RPM repository is included with Drupal VM, and you can make the following changes to use it to install PHP 5.6 instead of 7:

  1. Make sure you've followed the directions for switching to CentOS 7 in the [use a different base OS](base-os.md) guide.
  2. Change `php_version` inside `config.yml` to `"5.6"`.
