# Ansible Role: Ruby

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-ruby.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-ruby)

Installs Ruby and bundler gem on Linux.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    workspace: /root

The location where temporary files will be downloaded in preparation for Ruby installation.

    ruby_install_bundler: true

Whether this role should install [Bundler](http://bundler.io/).

    ruby_install_gems: []

A list of Ruby gems to install (just the name of the gem to be installed). This is meant as a simple convenience, and will only install the latest version of the gem. If you need to install gems with more options or specificity, you can do so elsewhere in your playbook.

    ruby_install_gems_user: username

The user account under which Ruby gems will be installed. Defaults to the `ansible_ssh_user` if not set.

    ruby_install_from_source: false

By default, this role will install whatever version of ruby is available through your system's package manager (`apt` or `yum`). You can install whatever version you like (including the latest release) by setting this to `true` and/or updating the `ruby_download_url` and `ruby_version`.

    ruby_download_url: http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.1.tar.gz

The URL from which Ruby will be downloaded (only used if `ruby_install_from_source` is `true`).

    ruby_version: 2.2.1

The version of ruby that will be installed (only used if `ruby_install_from_source` is `true`).

    ruby_rubygems_package_name: rubygems

The name of the `rubygems` package. Generally, the default should work; but it will be set to `rubygems-integration` automatically on Ubuntu Trusty (14.04).

## Dependencies

None.

## Example Playbook

    - hosts: server
      roles:
        - { role: geerlingguy.ruby }

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](http://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
