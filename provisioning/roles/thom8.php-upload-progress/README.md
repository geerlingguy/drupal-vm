# Ansible Role: Upload progress

[![CircleCI](https://circleci.com/gh/beetboxvm/ansible-role-beetbox-upload-progress.svg?style=svg)](https://circleci.com/gh/beetboxvm/ansible-role-beetbox-upload-progress)

Installs Upload progress PHP extension on Linux servers.

## Requirements

Prior to running this role, make sure the `php-devel` and `@Development Tools` (for RHEL/CentOS) or `php5-dev` + `build-essential` packages (for Debian/Ubuntu) are present on the system, as they are required for the build of Upload progress.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    workspace: /root

Where Xdebug setup files will be downloaded and built.

    php_uploadprogress_module_path: /usr/lib/php5/modules
    
The path where `uploadprogress.so` will be installed.
    
    php_uploadprogress_config_filename: 20-uploadprogress.ini
    
The file name for PHP config.

## Dependencies

  - geerlingguy.php

## Example Playbook

    - hosts: webservers
      roles:
        - { role: beetboxvm.upload-progress }

## License

MIT
