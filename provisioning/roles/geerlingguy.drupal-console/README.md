# Ansible Role: Drupal Console

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-drupal-console.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-drupal-console)

Installs [Drupal Console](http://drupalconsole.com/) on any Linux or UNIX system.

## Requirements

`php` (version 5.6+) should be installed and working.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    drupal_console_path: /usr/local/bin/drupal

The path where Drupal Console will be installed and available to your system. Should be in your user's `$PATH` so you can use Drupal Console by entering `drupal` instead of the full path.

    drupal_console_keep_updated: false

By default, this role not update Drupal Console when it is run again. If you'd like always update Drupal Console to the latest version when this role is run, switch this variable to `true`.

    drupal_console_config: ~/.console

The path to the Drupal Console configuration file.

## Dependencies

  - geerlingguy.php (Installs PHP).

## Example Playbook

    - hosts: servers
      roles:
        - role: geerlingguy.drupal-console

After the playbook runs, `drupal` will be placed in `/usr/local/bin/drupal` (this location is configurable), and will be accessible via normal system accounts.

## License

MIT / BSD

## Author Information

This role was created in 2015 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
