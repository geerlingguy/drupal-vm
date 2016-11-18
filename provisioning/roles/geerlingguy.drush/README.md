# Ansible Role: Drush

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-drush.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-drush)

Installs [Drush](http://www.drush.org/en/master/), a command line shell and scripting interface for Drupal, on any Linux or UNIX system.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    drush_install_path: /usr/local/share/drush

The location of the entire drush installation (includes all the supporting files, as well as the `drush` executable file.

    drush_path: /usr/local/bin/drush

The path where drush will be installed and available to your system. Should be in your user's `$PATH` so you can run commands simply with `drush` instead of the full path.

    drush_version: "master"

The version of Drush to install (examples: `"master"` for the bleeding edge, `"7.x"`, `"6.x"`, `"6.2.0"`). This should be a string as it refers to a git branch, tag, or commit hash.

    drush_keep_updated: no
    drush_force_update: no

Whether to keep Drush up-to-date with the latest revision of the branch specified by `drush_version`, and whether to force the update (e.g. overwrite local modifications to the drush repository).

    drush_composer_cli_options: "--prefer-source --no-interaction"

These options are the safest for avoiding GitHub API rate limits when installing Drush, and can be very helpful when working on dependencies/installation, but builds can be sped up substantially by changing the first option to --prefer-dist.

    drush_clone_depth: 1

Whether to clone the entire repo (by default), or specify the number of previous commits for a smaller and faster clone.

## Dependencies

  - geerlingguy.git (Installs Git).
  - geerlingguy.php (Installs PHP).
  - geerlingguy.composer (Installs Composer).

## Example Playbook

    - hosts: servers
      roles:
        - geerlingguy.drush

After the playbook runs, the `drush` command will be accessible from normal system accounts.

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](http://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
