# Ansible Role: PHP-MySQL

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-php-mysql.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-php-mysql)

Installs PHP [MySQL](https://www.mysql.com/) support on Linux.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    php_enablerepo: ""

(RedHat/CentOS only) If you have enabled any additional repositories (might I suggest geerlingguy.repo-epel or geerlingguy.repo-remi), those repositories can be listed under this variable (e.g. `remi,epel`). This can allow you to install later versions of PHP packages.

    php_mysql_package: php-mysql # RedHat
    php_mysql_package: php5-mysql # Debian

The PHP MySQL package to install via apt/yum. This should only be overridden if you need to install a unique/special package for MySQL support, as in the case of using software collections on Enterprise Linux.

## Dependencies

  - geerlingguy.php

## Example Playbook

    - hosts: webservers
      roles:
        - { role: geerlingguy.php-mysql }

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](http://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
