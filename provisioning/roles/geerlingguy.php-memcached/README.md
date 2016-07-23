# Ansible Role: PHP-Memcached

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-php-memcached.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-php-memcached)

Installs PHP Memcached support on RedHat/CentOS/Debian/Ubuntu.

## Requirements

This role doesn't *explicitly* require Memcached to be installed, but if you don't have the daemon running somewhere (either on the same server, or somewhere else), this role won't be all that helpful. Check out `geerlingguy.memcached` for a simple role to install and configure Memcached (either on the same server, or separate servers).

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    php_enablerepo: ""

(RedHat/CentOS only) If you have enabled any additional repositories (might I suggest geerlingguy.repo-epel or geerlingguy.repo-remi), those repositories can be listed under this variable (e.g. `remi,epel`). This can be handy, as an example, if you want to install the latest version of PHP from Remi's repository.

    php_memcached_package: php-memcached

The package to install for PHP Memcached support. For Debian/Ubuntu and PHP 5.x, use `php5-memcached`.

## Dependencies

  - geerlingguy.php

## Example Playbook

    - hosts: webservers
      roles:
        - { role: geerlingguy.php-memcached }

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](http://jeffgeerling.com/), author of [Ansible for DevOps](http://ansiblefordevops.com/).
