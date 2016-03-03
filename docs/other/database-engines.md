By default Drupal VM uses the package managers version of MySQL. If you're using RedHat 7 or CentOS 7 there is no MySQL package available and you need to use MariaDB instead.

## Using MySQL

This is the default setup for Drupal VM but for reference you need the following configuration in your `config.yml`

```yaml
# The database engine to use. Can be either 'mysql' or 'pgsql'.
drupal_database_engine: mysql

# MySQL Databases and users. If build_makefile: is true, first database will
# be used for the makefile-built site.
mysql_databases:
  - name: "{{ drupal_mysql_database }}"
    encoding: utf8
    collation: utf8_general_ci

mysql_users:
  - name: "{{ drupal_mysql_user }}"
    host: "%"
    password: "{{ drupal_mysql_password }}"
    priv: "{{ drupal_mysql_database }}.*:ALL"

installed_extras:
  - ...
  - mysql
```

## Using MariaDB

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

The configurations are the same as for MySQL and you can find out more options in the [`geerlingguy.mysql` Ansible role's README](https://github.com/geerlingguy/ansible-role-mysql#readme).

## Using PostgreSQL

If you prefer to use PostgreSQL instead of MySQL/MariaDB you can install it by changing the `drupal_database_engine` variable to `pgsql`:

```yaml
drupal_database_engine: pgsql
```

And adding `pgsql` to `installed_extras` list:

```yaml
installed_extras:
  - ...
  - pgsql
```

To create the drupal database and the database user also add this to your `config.yml`:

```yaml
# PostgreSQL
postgresql_databases:
  - name: "{{ drupal_mysql_database }}"
    owner: "{{ drupal_mysql_user }}"

postgresql_users:
  - name: "{{ drupal_mysql_user }}"
    pass: "{{ drupal_mysql_password }}"
    encrypted: no

postgresql_user_privileges:
  - name: "{{ drupal_mysql_user }}"
    db: "{{ drupal_mysql_user }}"
    priv: "ALL"
```

For more configuration options see the [`ANXS.postgresql` Ansible role's README](https://github.com/ANXS/postgresql#readme).
