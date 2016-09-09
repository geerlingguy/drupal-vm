# Ansible Role: Daemonize

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-daemonize.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-daemonize)

Installs [Daemonize](http://software.clapper.org/daemonize/), a tool for running commands as a Unix daemon.

## Requirements

Make sure you have `gcc` or other build tools installed (e.g. `yum install make automake gcc gcc-c++ kernel-devel` on RedHat, or `apt-get install build-essential` on Debian) prior to running this role, as it builds Daemonize from source.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    workspace: /root

The location where code will be downloaded and compiled.

    daemonize_version: 1.7.5

The daemonize release version to install.

    daemonize_install_path: "/usr"

The path where the compiled daemonize binary will be installed.

## Dependencies

None.

## Example Playbook

    - hosts: servers
      roles:
        - { role: geerlingguy.daemonize }

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](http://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
