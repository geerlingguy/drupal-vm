Drupal VM's configuration is designed to work with RedHat and Debian-compatible operating systems. Therefore, if you switch the `vagrant_box` in `config.yml` to any compatible OS, Drupal VM and all it's configuration should _Just Work™_... but that's not always the case.

Currently-supported OSes are:

  - Ubuntu 14.04 (default)
  - Ubuntu 12.04
  - RedHat Enterprise Linux / CentOS 7
  - RedHat Enterprise Linux / CentOS 6

For certain OSes, there are a couple other caveats and tweaks you may need to perform to get things running smoothly—the main features and latest development is only guaranteed to work with the default OS as configured in `example.config.yml`.

## RedHat Enterprise Linux / CentOS 7

**MySQL/MariaDB**: RHEL/CentOS 7 switched from using MySQL as the default database system to using MariaDB, so to make sure everything is configured properly, you need to add the following to `config.yml` so MariaDB installs correctly:

```yaml
mysql_packages:
  - mariadb
  - mariadb-server
  - mariadb-libs
  - MySQL-python
  - perl-DBD-MySQL
mysql_daemon: mariadb
mysql_socket: /var/lib/mysql/mysql.sock
mysql_log_error: /var/log/mariadb/mariadb.log
mysql_syslog_tag: mariadb
mysql_pid_file: /var/run/mariadb/mariadb.pid
```

**XHProf**: XHProf is installed in a different directory for RedHat/CentOS (as opposed to Debian/Ubuntu), you will need to update the `"xhprof.drupalvm.dev"` vhost to point to the `documentroot` `"/usr/share/pear/xhprof_html"`.

## RedHat Enterprise Linux / CentOS 6

**PHP OpCache**: PHP's OpCache (if you're using PHP > 5.5) requires the following setting to be configured in `config.yml` (see upstream bug: [CentOS (6) needs additional php-opcache package](https://github.com/geerlingguy/ansible-role-php/issues/39)):

```yaml
php_opcache_enabled_in_ini: false
```

**XHProf**: XHProf is installed in a different directory for RedHat/CentOS (as opposed to Debian/Ubuntu), you will need to update the `"xhprof.drupalvm.dev"` vhost to point to the `documentroot` `"/usr/share/pear/xhprof_html"`.