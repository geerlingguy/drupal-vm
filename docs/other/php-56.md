Drupal VM defaults to PHP 7, but you can install and use 5.6 if you need to maximize compatibility with older Drupal 6 and 7 sites.

_Note: If you have Ansible installed on your host machine, make sure you're running the latest version of all Ansible role dependencies by running `ansible-galaxy install -r provisioning/requirements.yml --force` inside the root Drupal VM project folder._

## Ubuntu 16.04

Ubuntu 16.04 Xenial defaults to PHP 7.0 in it's system packages. No older versions of PHP will be supported if using this base box.

## Ubuntu 14.04

Ondřej Surý's PPA for PHP 7.0 is used to install PHP 7, but you can switch to using different 5.6 packages instead by making the following changes to `config.yml`:

```yaml
php_version: "5.6"
php_packages:
  - php5
  - php5-apcu
  - php5-mcrypt
  - php5-cli
  - php5-common
  - php5-curl
  - php5-dev
  - php5-fpm
  - php5-gd
  - php5-sqlite
  - php-pear
  - libpcre3-dev
php_conf_paths:
  - /etc/php5/fpm
  - /etc/php5/apache2
  - /etc/php5/cli
php_extension_conf_paths:
  - /etc/php5/fpm/conf.d
  - /etc/php5/apache2/conf.d
  - /etc/php5/cli/conf.d
php_fpm_daemon: php5-fpm
php_fpm_conf_path: "/etc/php5/fpm"
php_fpm_pool_conf_path: "/etc/php5/fpm/pool.d/www.conf"
php_mysql_package: php5-mysql
```

If you're using Apache with `mod_php` you should also add `libapache2-mod-php5` to the `php_packages` list.

Also, if you're using one of the `installed_extras`, you may need to update the package names accordingly:

```yaml
# If you install `redis`:
php_redis_package: php5-redis

# If you install `memcached`:
php_memcached_package: php5-memcached

# If you install `xhprof`:
xhprof_download_url: https://github.com/phacility/xhprof/archive/master.tar.gz
xhprof_download_folder_name: xhprof-master
```

## RedHat/CentOS 7

Remi's RPM repository is included with Drupal VM, and you can make the following changes to use it to install PHP 5.6 instead of 7:

  1. Make sure you've followed the directions for switching to CentOS 7 in the [use a different base OS](base-os.md) guide.
  2. Change `php_version` inside `config.yml` to `"5.6"`.
