# Ansible Role: Drush

[![CI](https://github.com/geerlingguy/ansible-role-drush/workflows/CI/badge.svg?event=push)](https://github.com/geerlingguy/ansible-role-drush/actions?query=workflow%3ACI)

Installs [Drush](http://www.drush.org), a command line shell and scripting interface for Drupal, on any Linux or UNIX system.

## Requirements

PHP must be installed on the system prior to running this role (suggested role: `geerlingguy.php`).

Global composer installation requires Composer to also be installed on the system (suggested role: `geerlingguy.composer`).

Source installation additionally requires Git and Composer to also be installed on the system (suggested roles: `geerlingguy.git` and `geerlingguy.composer`).

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

### Drush Launcher

[Drush Launcher](https://github.com/drush-ops/drush-launcher) is a small wrapper around Drush for your global `$PATH`.

It is the recommended way to use `drush`, but there are some situations where you might wish to install and run Drush globally without using Drush Launcher. The following variables control Drush Launcher's installation:

    drush_launcher_install: true

Set to `no` if you don't want the launcher installed.

    drush_launcher_version: "0.6.0"

The version of the Drush Launcher to install. This should exactly match an available [Drush Launcher release](https://github.com/drush-ops/drush-launcher/releases).

    drush_launcher_phar_url: https://github.com/drush-ops/drush-launcher/releases/download/{{ drush_launcher_version }}/drush.phar

The URL from which the Drush Launcher phar file will be downloaded.

    drush_launcher_path: /usr/local/bin/drush

The path where drush will be installed and available to your system. Should be in your user's `$PATH` so you can run commands simply with `drush` instead of the full path.

### Drush global install via Composer

Some people need to have the full power of `drush` available globally, and this role allows the global install of Drush via Composer. If using this option, make sure you have Composer installed!

    drush_composer_global_install: false

Set to `yes` (and set `drush_launcher_install` to `false`) if you want to install `drush` globally using Composer.

    drush_composer_version: "~9.0"

The version constraint for the global Drush installation.

    drush_composer_update: false

Whether to run `composer update drush/drush` to ensure the version of Drush installed globally is the latest version.

    drush_composer_global_bin_path: ~/.config/composer/vendor/bin
    drush_composer_path: /usr/local/bin/drush

The global path where Composer installs global binaries, and the path in which you'd like the `drush` binary to be placed.

> NOTE: Composer 'global' installation is global _to the user under which Drush is installed_—e.g. if you install globally using the root user, `drush` will only work properly as `root` or when using `sudo`.

### Variables used for source install (Git).

You can also install Drush from source if you need a bleeding-edge release, or if you need a specific version which can't be installed via Composer.

    drush_install_from_source: false

Set to `yes` (and set `drush_launcher_install` to `false`) if you want to install `drush` globally using the Drush source code.

    drush_source_install_bin_path: /usr/local/bin/drush
    drush_source_install_path: /usr/local/share/drush

The location of the entire drush installation (includes all the supporting files, as well as the `drush` executable file.

    drush_source_install_version: "8.x"

The version of Drush to install (examples: `"master"` for the bleeding edge, `"8.x"`, `"7.x"`, `"6.2.0"`). This should be a string as it refers to a git branch, tag, or commit hash.

    drush_keep_updated: false
    drush_force_update: false

Whether to keep Drush up-to-date with the latest revision of the branch specified by `drush_version`, and whether to force the update (e.g. overwrite local modifications to the drush repository).

    drush_force_composer_install: false

Use this if you get an error message when provisioning like `Unable to load autoload.php. Run composer install to fetch dependencies and write this file`. It will force a `composer install` inside the Drush directory.

    drush_composer_cli_options: "--prefer-source --no-interaction"

These options are the safest for avoiding GitHub API rate limits when installing Drush, and can be very helpful when working on dependencies/installation, but builds can be sped up substantially by changing the first option to --prefer-dist.

    drush_clone_depth: 1

Whether to clone the entire repo (by default), or specify the number of previous commits for a smaller and faster clone.

## Dependencies

None.

## Example Playbook

    - hosts: servers
      roles:
        - geerlingguy.drush

After the playbook runs, the `drush` command will be accessible from normal system accounts.

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
