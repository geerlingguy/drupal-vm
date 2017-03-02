# Ansible Role: Drupal

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-drupal.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-drupal)

Builds and installs [Drupal](https://drupal.org/), an open source content management platform.

## Requirements

Drupal is a PHP-based application that is meant to run behind a typical LAMP/LEMP/LEPP/etc. stack, so you'll need at least the following:

  - Apache or Nginx (Recommended: `geerlingguy.apache` or `geerlingguy.nginx`)
  - MySQL or similar Database server (Recommended: `geerlingguy.mysql` or `geerlingguy.postgresql`)
  - PHP (Recommended: `geerlingguy.php` along with other PHP-related roles like `php-mysql`).

Drush is not an absolute requirement, but it's handy to have, and also required if you use this role to Install a Drupal site (`drupal_install_site: true`). You can use `geerlingguy.drush` to install Drush.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    drupal_install_site: true

Set this to `false` if you don't need to install Drupal (using the `drupal_*` settings below), but instead copy down a database (e.g. using `drush sql-sync`).

    drupal_build_makefile: false
    drush_makefile_path: "/path/to/drupal.make.yml"
    drush_make_options: "--no-gitinfofile"

Set this to `true` and `drupal_build_composer*` to `false` if you would like to build a Drupal make file with Drush.

    drupal_build_composer: false
    drupal_composer_path: "/path/to/drupal.composer.json"
    drupal_composer_install_dir: "/var/www/drupal"
    drupal_composer_dependencies:
      - "drupal/devel:1.x-dev"

Set `drupal_build_makefile` to `false` and this to `true` if you are using a Composer-based site deployment strategy.

    drupal_build_composer_project: true
    drupal_composer_project_package: "drupal-composer/drupal-project:8.x-dev"
    drupal_composer_project_options: "--prefer-dist --stability dev --no-interaction"

Set this to `true` and `drupal_build_makefile`, `drupal_build_composer` to `false` if you are using Composer's `create-project` as a site deployment strategy.

    drupal_core_path: "{{ drupal_composer_install_dir }}/web"
    drupal_core_owner: "{{ ansible_ssh_user | default(ansible_env.SUDO_USER, true) | default(ansible_env.USER, true) | default(ansible_user_id) }}"
    drupal_db_user: drupal
    drupal_db_password: drupal
    drupal_db_name: drupal
    drupal_db_backend: mysql

Required Drupal settings.

    drupal_domain: "drupaltest.dev"
    drupal_site_name: "Drupal"
    drupal_install_profile: standard
    drupal_enable_modules: [ 'devel' ]
    drupal_account_name: admin
    drupal_account_pass: admin

Settings for installing a Drupal site if `drupal_install_site` is `true`.

## Dependencies

N/A

## Example Playbook

See the example playbook used for Travis CI tests (in `tests/test.yml`) for a simple example. See also: [Drupal VM](https://www.drupalvm.com), which uses this role to set up Drupal.

Currently, this role assumes you've either already cloned an existing Drupal codebase into the `drupal_core_path`, you have a Drush make file or `composer.json` already configured to build your site, or you are building a brand new Drupal site (this is the default) using the [Composer template for Drupal projects](https://github.com/drupal-composer/drupal-project).

    - hosts: webserver
      vars_files:
        - vars/main.yml
      roles:
        - geerlingguy.apache
        - geerlingguy.mysql
        - geerlingguy.php
        - geerlingguy.php-mysql
        - geerlingguy.composer
        - geerlingguy.drush
        - geerlingguy.drupal

*Inside `vars/main.yml`*:

    drupal_install_site: true
    drupal_build_composer_project: true
    drupal_composer_install_dir: "/var/www/drupal"
    drupal_core_path: "{{ drupal_composer_install_dir }}/web"
    drupal_domain: "example.com"

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
