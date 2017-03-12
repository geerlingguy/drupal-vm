# Ansible Role: Composer

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-composer.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-composer)

Installs Composer, the PHP Dependency Manager, on any Linux or UNIX system.

## Requirements

  - `php` (version 5.4+) should be installed and working (you can use the `geerlingguy.php` role to install).
  - `git` should be installed and working (you can use the `geerlingguy.git` role to install).

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    composer_path: /usr/local/bin/composer

The path where composer will be installed and available to your system. Should be in your user's `$PATH` so you can run commands simply with `composer` instead of the full path.

    composer_keep_updated: false

Set this to `true` to update Composer to the latest release every time the playbook is run.

    composer_home_path: '~/.composer'
    composer_home_owner: root
    composer_home_group: root

The `COMPOSER_HOME` path and directory ownership; this is the directory where global packages will be installed.

    composer_version: ''

You can install a specific release of Composer, e.g. `composer_version: '1.0.0-alpha11'`. If left empty the latest development version will be installed. Note that `composer_keep_updated` will override this variable, as it will always install the latest development version.

    composer_global_packages: {}

A list of packages to install globally (using `composer global require`). If you want to install any packages globally, add a list item with a dictionary with the `name` of the package and a `release`, e.g. `- { name: phpunit/phpunit, release: "4.7.*" }`. The 'release' is optional, and defaults to `@stable`.

    composer_add_to_path: true

If `true`, and if there are any configured `composer_global_packages`, the `vendor/bin` directory inside `composer_home_path` will be added to the system's default `$PATH` (for all users).

    composer_project_path: /path/to/project

Path to a composer project.

    composer_add_project_to_path: false

If `true`, and if you have configured a `composer_project_path`, the `vendor/bin` directory inside `composer_project_path` will be added to the system's default `$PATH` (for all users).

    composer_github_oauth_token: ''

GitHub OAuth token, used to avoid GitHub API rate limiting errors when building and rebuilding applications using Composer. Follow GitHub's directions to [Create a personal access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) if you run into these rate limit errors.

    php_executable: php

The executable name or full path to the PHP executable. This is defaulted to `php` if you don't override the variable.

## Dependencies

None (but make sure you've installed PHP; the `geerlingguy.php` role is recommended).

## Example Playbook

    - hosts: servers
      roles:
        - geerlingguy.composer

After the playbook runs, `composer` will be placed in `/usr/local/bin/composer` (this location is configurable), and will be accessible via normal system accounts.

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
