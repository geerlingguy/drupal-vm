# Ansible Role: PHP Versions

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-php-versions.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-php-versions)

Allows different PHP versions to be installed when using the `geerlingguy.php` role (or a similar role). This role was originally built for [Drupal VM](https://www.drupalvm.com) but was released more generically so others could use an easier mechanism for switching PHP versions.

## Requirements

N/A

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    php_version: '7.1'

The PHP version to be installed. Any [currently-supported PHP major version](http://php.net/supported-versions.php) is a valid option (e.g. `5.6`, `7.0`, `7.1`, etc.

## Dependencies

  - geerlingguy.php is a soft dependency as the `php_version` variable is required to be set.
  - geerlingguy.repo-remi, if you're using CentOS or a Red Hat derivative.

## Example Playbook

    - hosts: webservers
    
      vars:
        php_version: '7.1'
    
      roles:
        - role: geerlingguy.repo-remi
          when: ansible_os_family == 'RedHat'
        - geerlingguy.php-versions
        - geerlingguy.php

## License

MIT / BSD

## Author Information

This role was created in 2017 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
