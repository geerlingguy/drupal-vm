# Drupal VM Changelog

## 4.1.1 (2016-12-30)

### Bugfixes

  * #1093: Install correct version of Apache on Ubuntu 12.04 and 14.04 for `SetHandler`.


## 4.1.0 "Anthem" (2016-12-30)

### Breaking Changes

  * N/A

### New/changed variables in default.config.yml

  * There's a new `apache_vhost_php_fpm_parameters` variable that defines the PHP-FPM handler Apache uses per-virtualhost. The old `extra_parameters` pre-4.1.0 will continue to work, but the new `SetHandler` technique is better for most scenarios than using `ProxyPassMatch`.
  * The Dashboard entry in `nginx_hosts` now has `is_php: true`.

### Improvements

  * #617: Switch to `SetHandler` instead of `ProxyPassMatch` (fixes #617, #876, #945, #1055).
  * #1090: Update docs to reference `SetHandler`.
  * #1047: Add docs on Drupal Console remote command execution.
  * #1076: Update PHP XDebug role to latest version
  * #1067: Configure hostname for environments other than VMs.
  * #1068: Add php-yaml extension.
  * #1078: Move Ansible version check to Vagrantfile for better UX.
  * #1071: Improve docs for SSL under Apache and Nginx.
  * #455: Move prod readme to docs instead of README file.

### Bugfixes

  * #1076: Fix PHP modules not re-compiling on PHP version changes.
  * #1061: Allow user defined post-provision-tasks to use tags.
  * #1060: Fix bug where dashboard assumes optional vhost docroot is defined.
  * #1062: Allow post-provision tasks to use the item variable.
  * #1059: Fix hostsupdater trying to add wildcard aliases.
  * #1054: Update Solr role to prevent permissions error.


## 4.0.0 "We've Got Company" (2016-12-10)

### Breaking Changes

  * Drush is now an optional `installed_extra`. **If you use Drush, and it's not installed as part of your own project's dependencies**, make sure you add `drush` as one of the `installed_extras` in your `config.yml`.
  * Vagrant 1.8.6 or later, VirtualBox 5.1.10 or later, and Ansible 2.2.0 or later (if installed on host) are now required.
  * PHP 7.0 is still the default, but **you can install PHP 7.1**, or **switch to PHP 5.6** on-the-fly, thanks to #1043—on any supported OS! See the updated docs: [Using other versions of PHP](http://docs.drupalvm.com/en/latest/other/php/)

### New/changed variables in default.config.yml

  * `drush` is now a default item in `installed_extras`.
  * `upload-progress` is now an optional item in `installed_extras`.
  * `drush_version` now defaults to `8.x` (`master` was causing issues with Drupal < 8).
  * `php_install_recommends` was removed from the default set of variables.
  * `solr_version` was bumped to `5.5.3` (was `5.5.2`).

### Improvements

  * #1043: Make switching PHP versions easier, and add support for PHP 7.1.
  * #711: Make Drush optional.
  * #788: Add optional PHP upload_progress support.
  * #992: Add optional `DRUPALVM_ANSIBLE_ARGS` support for Ansible CLI options.
  * #1002: Allow shallow Drush clones for faster builds.
  * #1007, #1009: Added a GitHub ISSUE_TEMPLATE to help my sanity.
  * #1018: Fix Solr versioning error in Solr role.
  * #823: Set composer.json type to `vm` instead of `project`.
  * Update following Ansible roles to newer versions: Solr, Nginx, Git, PHP, Firewall, Apache, PHP-XDebug, PHP-Redis.

### Bugfixes

  * #981: Bump minimum required Vagrant and VirtualBox versions.
  * #1014: Fix path in extra tasks example.
  * #1020: Switch to Drush `8.x` branch (instead of `master`/`9.x`) for Drupal 6/7 compatibility.
  * #1004: Add note about `php_pgsql_package` for PHP 5.6 (superceded by later work).
  * #1037: Fix Acquia configuration example for PHP 5.6 (superceded by later work).


## 3.5.2 (2016-11-17)

### Improvements

  * #983: Added a CHANGELOG.md (this thing you're reading!).
  * #872: Improve synced folder documentation for owner/group.
  * #847: Add documentation on using `vagrant-proxyconf` in local Vagrantfile.
  * #455: Environment-specific config file support (e.g. `prod.config.yml`).
  * #991: Reduce tasks run during Travis CI validation, clean up tests.
  * Update to latest role versions: PHP, PHP-PECL, Varnish, MySQL, Solr

### Bugfixes

  * #998: Fix documentation search capability on http://docs.drupalvm.com/en/latest/.
  * #947: Fix Varnish default configuration to purge correctly.
  * #989: Use latest (correct) version of Varnish role.
  * #980: CentOS install for Firewall and Mailhog fixed.
  * (No issue) Fix PHP 5.6 documentation to make sure PHP 7 doesn't also get installed.


## 3.5.1 (2016-11-07)

### Improvements

  * Update to latest version of Drush Ansible role for better composer performance.

### Bugfixes

  * #968: Fix for Ansible 2.2.x and PostgreSQL as database server.
  * #971: Fix for PHP 5.5 PPA usage on Ubuntu 12/14.
  * #912: Fix for Vagrant 1.8.6+ not mounting synced folders if `mount_options` is empty.


## 3.5.0 "Tron Scherzo" (2016-11-02)

### Breaking changes

  * Latest `geerlingguy/*` Vagrant box versions recommend VirtualBox 5.1.6+ and Vagrant 1.8.6+.
  * Roles should work with any Ansible version later than 2.0... but 2.2+ is now recommended.

### New/changed variables in default.config.yml

  * `drupalvm_vagrant_version_min` is now `1.8.6` (was `1.8.5`)

### Improvements

  * #950: Use default sync folder type for `vagrant-cachier` if present.
  * #957: Update various roles for better Ansible 2.2.x compatibility.
  * #962: Allow configuration of PHP `disable_functions`.
  * #963: Bump required Vagrant version.

### Bugfixes

  * #925: Fix MySQL install on CentOS 6.
  * #870: Fix invalid cron example syntax.
  * #956: Fix Apache failure if using Nginx as webserver.
  * #928: Fix rubocop test on Travis.
  * #927: Fix PHP docs duplicate config vars.
  * #936: Fix `mysql_*`/`db_*` variable names in documentation.


## 3.4.0 "Anthem for Keyboard Solo" (2016-10-12)

### Breaking changes

  * _If you have `selenium` in installed extras_: The `arknoll.selenium` role now defaults to installing Google Chrome / chromedriver instead of Firefox. See the role's [documentation](https://github.com/arknoll/ansible-role-selenium#variables) to see which variables should be set if you want to stick with Firefox (see: #924).
  * _If you're running PHP 5.6 with the `geerlingguy/ubuntu1404` box_: PHP 5.6 under Ubuntu 14.04 was using a deprecated PPA. Since switching to Ondrej's updated PPA, we had to also update the list of packages/paths in the [documentation for running PHP 5.6 under Drupal VM](http://docs.drupalvm.com/en/latest/other/php-56/). If you are using PHP 5.6, be sure to update your `php_*` variables (see: #921).

### New/changed variables in default.config.yml

  * `vagrant_memory` has been increased to `2048` (was `1024`).

### Improvements

  * #924: Upgrade to `arknoll.selenium` 2.0.0 role, adding support for Chrome/chromedriver with Selenium.
  * #922: Increase default memory usage from 1024 MB to 2048 MB.
  * #916: Document setup within Windows Subsystem for Linux / Ubuntu Bash environment.

### Bugfixes

  * #921: Switch to mainline/supported PHP 5.6.x releases instead of deprecated PPA releases.


## 3.3.2 (2016-10-06)

### New/changed variables in default.config.yml

  * You can now add `java` to `installed_extras` if you want Java installed without installing any of the other dependent extras (e.g. Apache Solr, Elasticsearch, or Selenium).

### Improvements

  * #915: Add 'java' as valid option in installed_extras


## 3.3.1 (2016-10-05)

### New/changed variables in default.config.yml

  * Updated the devel module version number in the `drupal_composer_dependencies` variable: formerly `"drupal/devel:8.*"`, now `"drupal/devel:1.x-dev"`.

### Bugfixes

  * #911: Document how to bypass/replace MailHog correctly.
  * #913: Update project version conventions for Composer-based installs since upstream drupal-project switched to using the drupal.org-hosted packagist.

## 3.3.0 "1990's Theme" (2016-09-30)

### Breaking changes

  * Update the three `drupal_mysql_*` variables to `drupal_db_*`.
  * Update the default `mysql_databases` and `mysql_users` variables to use the new variable names.

### New/changed variables in default.config.yml

  * `vagrant_cpus` set to `1` instead of `2` (see #855)
  * Added two variables to control minimum required dependency versions:
    * `drupalvm_vagrant_version_min: '1.8.5'`
    * `drupalvm_ansible_version_min: '2.1'`
  * Added `drupalvm_database` variable (defaults to `mysql`) to control database engine (see #146)
  * Changed `drupal_mysql_*` variables to `drupal_db_*` for better compatibility:
    * `drupal_mysql_user` is now `drupal_db_user`
    * `drupal_mysql_password` is now `drupal_db_password`
    * `drupal_mysql_name` is now `drupal_db_name`
  * Updated `mysql_databases` and `mysql_users` to use the new variable names listed above
  * Added `postgresql_databases` and `postgresql_users` (same kind of structure as the `mysql_*` variables)

### Improvements

  * #146: Add PostgreSQL support.
  * #908: Require minimum version of Ansible 2.1.0, Vagrant 1.8.5.
  * #855: Default to 1 vCPU core for better VirtualBox performance.
  * Update PHP-MySQL Ansible role.
  * #421, #367: Add to Behat/Selenium documentation.

### Bugfixes

  * Ensure Debian apt caches are updated when running tests on Travis.


## 3.2.3 (2016-09-27)

### Improvements

  * Updated all Ansible roles to latest releases (stability fixes).
  * Updated Travis CI tests to use more efficient Docker setup.

### Bugfixes

  * Nothing substantial, just a few typo corrections in comments.


## 3.2.2 (2016-09-09)

### Breaking changes

N/A

### New/changed variables in default.config.yml

N/A

### Improvements

  * #870: Use more compact and legible object syntax for cron example.
  * #886: Allow forcing use of ansible_local even if ansible is present on host.

### Bugfixes

  * #889: Document Parallels requires paid version.
  * #845: Fix missing config.yml file in newrelic role.
  * #896: Update Node.js role to fix Nodesource SSL issues on older OSes. Update other roles too.


## 3.2.1 (2016-08-16)

### New/changed variables in default.config.yml

  * Default database defined in `mysql_databases` now uses `utf8mb4` encoding and `utf8mb4_general_ci` collation.
  * `selenium_version` now defaults to `2.53.0`

### Improvements

  * #866: Use latest Selenium release.
  * #859: Only set `mysql_enablerepo` when not defined.
  * #856: Link Nginx CGI timeout time to PHP timeout time.
  * #846: Default to Drupal 8.1.8.
  * #839: Don't throw warning if `VAGRANTFILE_API_VERSION` is set twice.
  * (No issue): Bump required role versions to latest point releases.

### Bugfixes

  * #853: Add `/web` to directory in Drupal Console instructions.


## 3.2.0 "Tronaction" (2016-07-26)

### Breaking changes

Drupal VM now uses Vagrant's `ansible_local` provisioner if you don't have Ansible installed on your host. Make sure you're running Vagrant 1.8.2 or later (1.8.5+ recommended!).

### New variables in default.config.yml

  * `drush_make_options: "--no-gitinfofile"` added to allow overriding of the default options passed into the `drush make` command.
  * `elasticsearch` is now an optional `installed_extra`
  * port `9200` is now included in the list of `firewall_allowed_tcp_ports` (to support optional Elasticsearch installation)
  * `solr_version: "5.5.2"` – the default Solr version was bumped from 5.5.1 to 5.5.2.

### Improvements

  * #814 / #815: Include roles in Drupal VM codebase (for faster/more stable install).
  * #803: Add optional Elasticsearch installation.
  * #450: Switch to Vagrant 1.8.2+'s `ansible_local` provisioner.
  * #807: Add ability to override `drush make` CLI options.
  * #775: Recommend manual VirtualBox installation as part of Quick Start guide.
  * #777: Document how to switch Java versions for newer Apache Solr versions.

### Bugfixes

  * #800: Add php5-apcu to default Acquia Cloud package list.
  * #798: Update selenium role so it doesn't cause build failure.
  * #821: Bump upstream Solr role version to fix some Solr install bugs.
  * #825: Fix typo in dashboard.
  * #799: Quote the Drupal core version in the example makefile to avoid duck typing problems.


## 3.1.4 (2016-07-11)

### Breaking changes

  * `php_sendmail_path` now defaults to `"/opt/mailhog/mhsendmail"` (see https://github.com/geerlingguy/drupal-vm/commit/2d835826de127e427b9a8287bdd2d84a65779761)

### Improvements

  * #776: Switch from ssmtp to mhsendmail.
  * #782: Favicon for Drupal VM dashboard page.
  * #791: Update URLs to https (yay Let's Encrypt!).
  * #794: Bump PHP role version so FPM user is configurable.
  * (No issue): Bump MySQL role version so large innodb prefixes are configurable.

### Bugfixes

  * #795: Fix Your Site links on dashboard for certain Nginx configs.
  * #793: Document composer.json devel module dependency for default config.


## 3.1.3 (2016-06-29)

## Improvements

  * #762: Support including extra_parameters for nginx vhosts.

## Bugfixes

  * #744: Fix npm_config_prefix directory created under root instead of vagrant.
  * #766: Document requirement of `vagrant_box: ubuntu1404` for PHP 5.6.
  * #726: Fix permissions on the synced folder for composer project build.


## 3.1.2 (2016-06-16)

### Improvements

  * #730: Improve dashboard for users who have ip set to `0.0.0.0`.
  * #733: Update example composer.json to work with Drupal.org packagist.

### Bugfixes

  * #736: Fix hardcoded NFS reference that broke on Windows with vagrant-cachier plugin.
  * #734: Fix a setting that caused Vagrant 1.8.3/1.8.4 to fail to mount shared folders.
  * #733 and #741: Adjust composer and timeout values to be more robust with slower filesystems.
  * Bumped composer role version.


## 3.1.1 (2016-06-12)

### New variables in default.config.yml

  * `#ssh_home: "{{ drupal_core_path }}"` - The `SSH_HOME` the default Drupal VM user would be redirected to upon SSH login (e.g. `vagrant ssh`). This new variable is entirely optional and commented by default.

### Improvements

  * #709: Add strict vagrant version requirement for easier debugging.
  * #707: Use official packages.drupal.org for Composer drupal package repository.
  * #724: Add default www.drupalvm.dev alias to Apache and Nginx vhosts.
  * #725: Better ordering and description of Drupal-related variables in `default.config.yml`.
  * #665: Add ssh_home var as default pwd for SSH.

### Bugfixes

  * #715: Set node global install directory to a location writable by the vagrant user.
  * #726: Ensure correct permissions when using Composer create-project.
  * #650: Bump MySQL role version to fix root user account password.


## 3.1.0 "Love Theme" (2016-06-06)

### New variables in default.config.yml

  * `local_path: .` - the default Vagrant synced folder `local_path` is set to the Drupal VM directory. This way multiple copies of Drupal VM can have independent Drupal codebases by default.
  * `build_makefile: false` - Drupal VM now defaults to a composer-based workflow. To keep using a makefile, set this `true` and set all the `build_composer*` variables to `false`.
  * `build_composer`, `drupal_composer_*`, `build_composer_project`, `drupal_composer_project_*` - New variables to support `composer.json` or `composer create-project` site builds.
  * `extra_parameters` added to the default Apache vhost definition for the Drupal VM dashboard (to support displaying PHP information on the dashboard).
  * `hirak/prestissimo` added to `composer_global_packages` (to speed up Composer operations inside the VM).
  * `solr_version: "5.5.1"` - New default version of Apache Solr, if `solr` is in `installed_extras`.
  * `configure_local_drush_aliases` has been changed to `configure_drush_aliases` (there is a shim to allow the use of the old variable name).

### Improvements

  * #648: Make config.yml optional (always load default configuration).
  * #693: Default to Apache Solr 5.x.
  * #687: Default the synced folder to the Drupal VM directory.
  * #688: Add docs on how to run custom Ansible playbooks using a local Vagrantfile.
  * #694, #701: Add support for, and default to, Composer-based Drupal 8 site builds.
  * #698: Add docs about `vagrant-bindfs` to help those with NFS permissions issues.
  * #703: Include default `vagrant-cachier` configuration, with an :apt bucket and a :generic bucket for Composer.
  * #705: Add Packagist project badge.
  * #706: Updated docs for 3.1.0 and default Composer workflow.

### Bugfixes

  * #654: Remove ansible.cfg because role install is handled by Vagrant.
  * #653: Update docs for PHP 5.6 and apcu.
  * #663: Change `configure_local_drush_aliases` to `configure_drush_aliases` so it's purpose is clearer.
  * #678: Clarify requirement of Ansible on host for host Drush alias setup.


## 3.0.0 "The Light Sailer" (2016-05-19)

Read the [Drupal VM 3 announcement blog post](http://www.jeffgeerling.com/blog/2016/drupal-vm-3-here).

### Breaking changes

  * Some new defaults (e.g. PHP 7 or upgrading to Ubuntu 16.04) require a full box rebuild (`vagrant destroy` and `vagrant up`)
  * Requirements: Vagrant 1.8.1+, VirtualBox 5.0.20+, and (if using Ansible installed locally) Ansible 2.0.1+.

### New variables in config.yml

  * `vagrant_box` now defaults to `geerlingguy/ubuntu1604` (was `geerlingguy/ubuntu1404`)
  * `drush_makefile_path` is now `"{{ config_dir }}/drupal.make.yml"` (to support Drupal VM in a subdirectory)
  * `memcached`, `xdebug`, and `xhprof` are now commented from `installed_extras` by default
  * `extra_packages` now includes `sqlite` by default
  * `php_version` is now `"7.0"`

### Improvements

  * #522: Add SQLite support to Drupal VM.
  * #455: Add support for local.config.yml.
  * #608: Automate `ansible-galaxy` role installation (requires Vagrant 1.8+).
  * #609: Default to Ubuntu 16.04, PHP 7, and MySQL 5.7.
  * #616: Update Travis CI automated tests to test on Ubuntu 16.04 in addition to other OSes.
  * #618: Use latest stable Drupal 8 release instead of working-copy (git clone) by default.
  * #633: Support custom pre/post provision Ansible task files.
  * #378: Decouple Drupal VM from it's existing directory so it can be managed in other directories.
  * #378: Add a composer.json ([Drupal VM is on Packagist!](https://packagist.org/packages/geerlingguy/drupal-vm))
  * #526: Added Blackfire.io support (PHP 7 or 5.x).

### Bugfixes

  * #614: Install cron jobs as the SSH user instead of as root.
  * #620: Update JJG-Ansible-Windows to latest version.
  * #635: PHP 5.6 documentation didn't include required `php_fpm_pool_conf_path`.
  * #619: Fix OpCache CLI error caused by conflicting ini files.


## 2.5.1 (2016-05-11)

## 2.5.0 "Magic Landings" (2016-05-10)

## 2.4.0 "A New Tron and the MCP" (2016-03-30)

## 2.3.1 (2016-02-23)

## 2.3.0 "Miracle and Magician" (2016-02-20)

## 2.2.1 (2016-01-25)

## 2.2.0 "Wormhole" (2016-01-15)

## 2.1.2 (2015-12-04)

## 2.1.1 (2015-10-07)

## 2.1.0 (2015-09-22)

## 2.0.1 (2015-08-21)

## 2.0.0 (2015-07-29)

...

## 1.0.0 (2014-03-24)
