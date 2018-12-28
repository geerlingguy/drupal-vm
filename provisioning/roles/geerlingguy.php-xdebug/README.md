# Ansible Role: PHP-XDebug

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-php-xdebug.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-php-xdebug)

Installs PHP [XDebug](http://xdebug.org/) on Linux servers.

## Requirements

Prior to running this role, make sure the `php-devel` and `@Development Tools` (for RHEL/CentOS) or `php5-dev` + `build-essential` packages (for Debian/Ubuntu) are present on the system, as they are required for the build of Xdebug.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    workspace: /root

Where Xdebug setup files will be downloaded and built.

    php_xdebug_version: 2.6.0

The version of Xdebug to be installed (see [Updates](https://xdebug.org/updates.php) for a current listing). **If using PHP 5.6**: Set this to `2.5.0` or earlier, as starting with XDebug 2.6.0, PHP 5.x support has been dropped.

    php_xdebug_default_enable: 1
    php_xdebug_coverage_enable: 1

Whether to enable XDebug coverage and default exception handling or not. Disable these for slightly improved PHP performance, enable these to use XDebug to the fullest extent.

    php_xdebug_module_path: /usr/lib64/php/modules

The path where `xdebug.so` will be installed.

    php_xdebug_remote_enable: "false"

Whether remote debugging is enabled.

    php_xdebug_remote_connect_back: "false"

If this is set to true, Xdebug will respond to any request from any IP address; use only for local development on non-public installations!

    php_xdebug_remote_host: localhost
    php_xdebug_remote_port: "9000"

The host and port on which Xdebug will listen.

    php_xdebug_remote_log: /tmp/xdebug.log

The location of the xdebug log (useful if you're having trouble connecting).

    php_xdebug_idekey: sublime.xdebug

The IDE key to use in the URL when making Xdebug requests (e.g. `http://example.local/?XDEBUG_SESSION_START=sublime.xdebug`).

    php_xdebug_max_nesting_level: 256

The maximimum function nesting level before Xdebug bails and throws a fatal exception.

    php_xdebug_cli_disable: false

(Debian/Ubuntu ONLY) Disable xdebug for the CLI SAPI.

## Dependencies

  - geerlingguy.php

## Example Playbook

    - hosts: webservers
      roles:
        - { role: geerlingguy.php-xdebug }

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](http://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
