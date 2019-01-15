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

    blackfire_gpg_key_url: https://packages.blackfire.io/gpg.key
    blackfire_repo_url: http://packages.blackfire.io/fedora/blackfire.repo

Variables used for Blackfire package setup and installation.

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

This role was created in 2016 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
