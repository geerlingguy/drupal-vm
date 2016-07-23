# Ansible Role: Blackfire

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-blackfire.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-blackfire)

Installs [Blackfire](https://blackfire.io/) on RHEL/CentOS or Debian/Ubuntu.

## Requirements

After installation, you need to complete Blackfire setup manually before profiling:

  1. Register the Blackfire agent: `sudo blackfire-agent -register`
  2. Configure Blackfire: `blackfire config`

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    blackfire_packages:
      - blackfire-agent
      - blackfire-php

The Blackfire packages this role will install on the server. Note that `blackfire-php` may not work well with XHProf and/or XDebug.

## Dependencies

Requires the `geerlingguy.php` role.

## Example Playbook

    - hosts: webserver
      roles:
        - geerlingguy.php
        - geerlingguy.blackfire

## License

MIT / BSD

## Author Information

This role was created in 2016 by [Jeff Geerling](http://jeffgeerling.com/), author of [Ansible for DevOps](http://ansiblefordevops.com/).
