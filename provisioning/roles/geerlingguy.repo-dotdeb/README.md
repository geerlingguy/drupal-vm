# Ansible Role: DotDeb Repository

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-repo-dotdeb.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-repo-dotdeb)

Installs the [DotDeb repository](https://www.dotdeb.org/) for Debian.

## Requirements

This role only is needed/runs on Debian and its derivatives.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    dotdeb_sources:
      - "deb http://packages.dotdeb.org {{ ansible_distribution_release }} all"
      - "deb-src http://packages.dotdeb.org {{ ansible_distribution_release }} all"
    dotdeb_repo_gpg_key_url: https://www.dotdeb.org/dotdeb.gpg

The DotDeb repos and GPG key URL. Generally, these should not be changed, but if this role is out of date, or if you need a very specific version, these can both be overridden.

## Dependencies

None.

## Example Playbook

    - hosts: servers
      roles:
        - geerlingguy.repo-dotdeb

## License

MIT / BSD

## Author Information

This role was created in 2016 by [Jeff Geerling](http://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
