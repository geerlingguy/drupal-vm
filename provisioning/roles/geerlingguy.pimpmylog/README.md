# Ansible Role: Pimp My Log

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-pimpmylog.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-pimpmylog)

Installs [Pimp my Log](http://pimpmylog.com/).

## Requirements

Requires PHP to be installed on the server, and a web server like Apache, Nginx, IIS. You can get Pimp my Log set up pretty quickly with this role in tandem with `geerlingguy.apache` and `geerlingguy.php` available on Ansible Galaxy.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    pimpmylog_install_dir: /var/www/pimpmylog

The location where Pimp my Log will be installed. You should configure a virtual host or server entry pointing to this directory so you can access the interface. Otherwise, you could choose a location that's within an existing docroot, e.g. the default docroot `/var/www/html/pimpmylog`, and access Pimp my Log at `http://localhost/pimpmylog/`.

    pimpmylog_repo: https://github.com/potsky/PimpMyLog.git

The git repository URL from which Pimp my Log will be cloned.

    pimpmylog_version: master

The version of Pimp my Log to install. Can be any valid tag, branch, or `HEAD`.

    pimpmylog_grant_all_privs: no

The setup of Pimp my Log allows for auto-configuration if the installation directory has `777` privileges, but this is an insecure way to install Pimp my Log. If you're installing on a local development environment, this is relatively harmless to set to `yes` to ease in installation... but if you're running this on a production or publicly-available server, don't even _think_ about changing this value!

## Dependencies

None.

## Example Playbook

    - hosts: webservers
      roles:
        - { role: geerlingguy.apache }
        - { role: geerlingguy.php }
        - { role: geerlingguy.pimpmylog }

## License

MIT / BSD

## Author Information

This role was created in 2015 by [Jeff Geerling](http://jeffgeerling.com/), author of [Ansible for DevOps](http://ansiblefordevops.com/).
