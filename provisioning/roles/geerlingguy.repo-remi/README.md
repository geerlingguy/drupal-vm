# Ansible Role: Remi Repository

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-repo-remi.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-repo-remi)

Installs [Remi's RPM repository](http://rpms.famillecollet.com/) for RHEL/CentOS.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    remi_repo_url: "http://rpms.famillecollet.com/enterprise/remi-release-{{ ansible_distribution_major_version }}.rpm"

The URL from which the Remi repo `.rpm` will be downloaded and installed.

    remi_repo_gpg_key_url: "http://rpms.remirepo.net/RPM-GPG-KEY-remi"

Remi repo GPG key location. Can be set to a local file or to the URL from Remi's website.

## Dependencies

None.

## Example Playbook

    - hosts: servers
      roles:
        - geerlingguy.repo-remi

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](http://jeffgeerling.com/), author of [Ansible for DevOps](http://ansiblefordevops.com/).
