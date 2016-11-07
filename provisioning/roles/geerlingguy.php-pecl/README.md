# Ansible Role: PHP PECL extensions

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-php-pecl.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-php-pecl)

Installs PHP PECL extensions on servers with PHP already installed.

## Requirements

PHP must already be installed on the server (along with the package `php-pear`), so the `pecl` command can be run.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    php_pecl_install_command: "pecl install"

The command that will be run to install extensions. The default is generally correct, but if you're running Ubuntu 14.04 LTS and run into [this issue](https://github.com/geerlingguy/ansible-role-php-pecl/pull/7), you should override this default with `"pecl install -Z"`

    php_pecl_extensions: []

A list of extensions that should be installed via `pecl install`. If you'd like to have this role install extensions like XDebug, just add it in the list, like so:

    php_pecl_extensions:
      - xdebug

## Dependencies

  - geerlingguy.php

## Example Playbook

    - hosts: webservers
      vars_files:
        - vars/main.yml
      roles:
        - { role: geerlingguy.php-pecl }

*Inside `vars/main.yml`*:

    php_pecl_extensions:
      - xdebug

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](http://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
