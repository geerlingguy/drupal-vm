Since Drupal VM is built in a modular fashion, and the upstream Ansible Role that installs and configures MySQL is built in a way that works with any MySQL-compatible replacement, you can easily swap out MySQL for MariaDB.

The simplest way is to add the following lines after the `# MySQL Configuration.` line in `config.yml`:

```yaml
mysql_packages:
  - mariadb-client
  - mariadb-server
  - python-mysqldb
```

This set of packages works out of the box with the default Ubuntu 14.04 installation that comes with Drupal VM.

Alternatively, if you want to use RedHat 7 or CentOS 7 instead of Ubuntu, you can set the following variables to install and configure MariaDB instead of MySQL:

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