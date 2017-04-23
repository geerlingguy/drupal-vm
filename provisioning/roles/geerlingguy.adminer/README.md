# Ansible Role: Adminer

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-adminer.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-adminer)

An Ansible Role that installs [Adminer](http://www.adminer.org/) on almost any computer.

## Requirements

You need to have PHP and MySQL for Adminer to do anything useful. If you have Apache installed, Adminer will add in configuration to make Adminer accessible on any virtualhost at `/adminer`; set `adminer_add_apache_config` to `false` to disable this behavior.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    adminer_install_dir: /opt/adminer

The directory in which Adminer will be downloaded/installed.

    adminer_install_filename: adminer.php

The filename for the downloaded Adminer application. If you're managing virtualhosts or server directives manually, it might be simpler to set the document root to your configured `adminer_install_dir`, and the filename to `index.php`, so you don't have to enter `/adminer.php` in the URL to access Adminer.

    adminer_symlink_dirs: []

Directories inside which you would like `adminer.php` symlinked. Can be useful if you just want to toss the script into a docroot and access it at `sitename/adminer.php`.

    adminer_add_apache_config: false

Set this to `true` to tell Adminer to add a config file to Apache so you can access it at `hostname/adminer` on any configured virtualhost, using an Apache `Alias` directive. The role will also restart Apache so this configuration takes effect immediately.

## Dependencies

None. If `adminer_add_apache_config` is set to `true`, it will use some variables and handlers defined by the `geerlingguy.apache` role, so there's a soft dependency on that role.

## Example Playbook

    - hosts: servers
      roles:
        - { role: geerlingguy.adminer }

## License

MIT / BSD

## Author Information

This role was created in 2015 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/). It is originally a fork of [Oefenweb/ansible-adminer](https://github.com/Oefenweb/ansible-adminer).
