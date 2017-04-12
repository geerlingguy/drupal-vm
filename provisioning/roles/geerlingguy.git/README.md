# Ansible Role: Git

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-git.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-git)

Installs Git, a distributed version control system, on any RHEL/CentOS or Debian/Ubuntu Linux system.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    workspace: /root

Where certain files will be downloaded and adjusted prior to git installation, if needed.

    git_enablerepo: ""

This variable, a well as `git_packages`, will be used to install git via a particular `yum` repo if `git_install_from_source` is false (CentOS only). Any additional repositories you have installed that you would like to use for a newer/different Git version.

    git_packages:
      - git
      - git-svn

The specific Git packages that will be installed. By default, `git-svn` is included, but you can easily add this variable to your playbook's variables and remove `git-svn` if desired.

    git_install_from_source: false
    git_install_path: "/usr"
    git_version: "2.1.0"

Whether to install Git from source; if set to `true`, `git_version` is required and will be used to install a particular version of git (see all available versions here: https://www.kernel.org/pub/software/scm/git/), and `git_install_path` defines where git should be installed.

    git_install_from_source_force_update: false

If git is already installed at and older version, force a new source build. Only applies if `git_install_from_source` is `true`.

## Dependencies

None.

## Example Playbook

    - hosts: servers
      roles:
        - { role: geerlingguy.git }

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
