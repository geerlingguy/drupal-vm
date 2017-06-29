# Drupal VM Changelog

## 4.6.0 "Water, Music, and Tronaction" (2017-06-28)

### Breaking Changes

  * If you have `varnish` in your `installed_extras`, then the newest version of the Varnish role included in this release changes the Varnish package repository (on all OSes) to use the latest supported Varnish packages from Varnish's official packagecloud.io repos. This allows you to specify Varnish versions anywhere from the latest (currently 5.1) to early 2.x versions (and everything in-between)... but you might either have to uninstall Varnish before updating existing VMs, or just rebuild your VM to take advantage of the latest role version.

### New/changed variables in default.config.yml

  * `vagrant_box` still defaults to Ubuntu 16.04, but you can now use Debian 9 ('Stretch') if you set the variable to `geerlingguy/debian9`.
  * `vagrant_plugins` was added (see #1378), and contains a list of Vagrant plugins that—if not already installed—will be installed for use by Vagrant.

### Improvements

  * #1455: Update Varnish role to allow for Varnish 5.1, 5.0, and any older version.
  * #1451: Document the availability of `geerlingguy/debian9` base box (and Docker base container).
  * #1378: Automatically install a configurable list of Vagrant plugins (`hostsupdater` and `vbguest` by default).
  * #1423: Add documentation on using the official Docker image for quick Drupal testing environments.
  * #1388, #1389: Use `geerlingguy/drupal-vm` docker image by default in Docker Compose file.
  * #1437: Allow list of paths in `pre_provision_tasks_dir` and `post_provision_tasks_dir` (used to just be one path maximum).
  * #1443: Add IRC badge linking to `#drupal-vm` freenode IRC room on Riot.
  * #1171: Support using XDebug to debug Drush commands inside Drupal VM.
  * #1368: Ensure private filesystem works correctly when using Nginx.
  * #1375: Allow /vagrant default synced folder to be managed like other synced folders.
  * #1406: Minor doc improvement for using Tideways instead of XHprof when using PHP 7+.
  * #1431: Minor doc improvement for `composer docker-bake` command.
  * #1386: Remove dated Acquia example and point to BLT's configuration instead.
  * #1418: Allow PHP configuration to be overridden so default system packages can be used instead of Ondrej Sury's repo (allowing PHP 5.3, 5.4, and 5.5 to be used when absolutely necessary).
  * #1424: Add support for RFC 5785 (`.well-known`) when using Nginx.
  * #1451: Use 192.168.89.89 for default Docker Drupal VM IP.
  * Updated roles: PostgreSQL, PHP Versions, Redis, Nginx, Varnish.

### Bugfixes

  * #1403: Ensure PostgreSQL works correctly on all supported OSes.
  * #1399: Fix bug where Drupal would reinstall on reprovision if not using English as the default language.
  * #1384, #1420: Update docs in Solr example for more clarity concerning use with Drupal 8.
  * #1444: Fix outdated comment for `drupal_install_site` variable.
  * #1411: Fix `.gitignore` file applying rules to files in subdirectories.


## 4.5.0 "Break In (For Strings, Flutes, and Celesta)" (2017-05-24)

### Breaking Changes

  * The default `nodejs_version` is now set to `6.x`; if you need to stay on `0.12` or some other version, be sure to set the version explicitly in your own `config.yml`.

### New/changed variables in default.config.yml

  * Changed variables:
    * `nodejs_version: "6.x"` (was `0.12`)
  * New variables:
    * Reconfigurable templates for Drush Aliases:
      * `drush_aliases_host_template: "templates/drupalvm.aliases.drushrc.php.j2"`
      * `drush_aliases_guest_template: "templates/drupalvm-local.aliases.drushrc.php.j2"`
    * Reconfigurable template for Nginx hosts:
      * `nginx_vhost_template: "templates/nginx-vhost.conf.j2"`
    * `firewall_enabled: true` (allows the disabling of Drupal VM's default firewall, e.g. for Docker usage)
    * `php_xdebug_remote_host: "{{ ansible_default_ipv4.gateway }}"` (prevents warnings when using Xdebug)
    * New Docker configuration options:
      * `docker_container_name: drupal-vm`
      * `docker_image_name: drupal-vm`
      * `docker_image_path: ~/Downloads`
    * New hostname configuration options:
      * `hostname_configure: true`
      * `hostname_fqdn: "{{ vagrant_hostname }}"`

### Improvements

  * #1206: Add instructions for running Drupal VM inside Docker.
  * #1356: Add an official geerlingguy/drupal-vm image on Docker Hub.
  * #1366: Make Drupal VM Docker image easier to use for single-site installations.
  * #1377: Extract php-versions (version switching tasks) into standalone role so anyone can use it.
  * #1353: Update default Node.js version to 6.x.
  * #1327: Refactor task includes into drupalvm Ansible roles.
  * #1329: Update Nginx role, allowing use of extensible Nginx templates.
  * #1254: Refactor Drupal VM's Nginx templates to allow for extensibility.
  * #1349: Make it easier to install Node.js global packages by name.
  * #1258: Finalize documentation for Git-based deployment.
  * Updated roles: Firewall, Nginx, Node.js, Apache, Selenium.

### Bugfixes

  * #1351: Fix documentation bug concerning paths in example.drupal.composer.json.
  * #1304: Fix documentation bug concerning Behat paths.
  * #1350: Set the `php_xdebug_remote_host` to prevent Xdebug warnings.
  * #1347: Fix LoadError message on vagrant up/down.


## 4.4.5 (2017-04-24)

### New/changed variables in default.config.yml

  * `drupalconsole` is no longer enabled globally by default (see #1335 and #1338).

### Improvements

  * #1333: Add docs on using Drupal VM with Wordpress and other PHP apps.

### Bugfixes

  * #1335: Update Drupal Console Role so it works correctly with rc17 and beyond.
  * #1338: Remove drupalconsole from default installed_extras list.


## 4.4.4 (2017-04-22)

### New/changed variables in default.config.yml

  * N/A

### Improvements

  * #1271: Don't run PHP role for 'drupal' tag.
  * Updated Ansible roles: `postgresql`, `drupal`.
  * #1323: Default synced folder type to `vagrant_synced_folder_default_type` if unset.

### Bugfixes

  * #1324: Only depend on `geerlingguy.nginx` when `drupalvm_webserver` is `nginx`.


## 4.4.3 (2017-04-20)

### New/changed variables in default.config.yml

  * Added `ssh_home: "{{ drupal_core_path }}"` so `vagrant ssh` drops you directly into the core path by default.

### Improvements

  * Updated Ansible roles: `mysql`, `solr`, `nodejs`, `drupal`, `varnish`.
  * #1177: Mention the availability of the `geerlingguy/debian8` base box.
  * #1265: Document reverse-mount shares. Also scaffolds Issue #1258.
  * #1272: Set ssh_home by default since it's really helpful.
  * #1259: Update some performance-related docs.
  * #1317: Remove duplicate handler and extract www tasks into new role.

### Bugfixes

  * #1294: Fix 'Cannot load Zend OPcache' notice.
  * #1306: Fix Ansible 2.3-related bug with jinja2 inside when statement.
  * #1302: Remove `ansible_ssh_user` variable to avoid upstream bugs.
  * #1314: Revert "Move simple `include_vars` statement to `vars_files`"


## 4.4.2 (2017-04-12)

### New/changed variables in default.config.yml

  * N/A

### Improvements

  * Updated Ansible roles: `firewall`, `mailhog`, `apache`, `git`, `mysql`, `solr`, `adminer`, and `varnish`.
  * #1289: Update Linux host docs to mention encryption as primary reason for NFS issues.

### Bugfixes

  * #1280: Documentation bugfix for a Quick Start Guide link.
  * #1275: Update Adminer role to prevent download timeouts.
  * #1281: Avoid TypeError when a configuration file is empty.
  * #1291: Teensy tiny docs grammar fix.


## 4.4.1 (2017-04-01)

### New/changed variables in default.config.yml

  * N/A

### Improvements

  * Updated Ansible roles: `drupal`, `drush`, and `solr`.

### Bugfixes

  * #1245: Follow-up to make sure VM initial provisioning works as expected.
  * #1261: Run hostname.yml tasks for `drupal` tag to prevent errors.
  * Fixed pareview.sh script configuration example.
  * Tweaked docs for Selenium and Production for clarity.


## 4.4.0 "Sea of Simulation" (2017-03-24)

### Breaking Changes

  * No breaking changes.

### New/changed variables in default.config.yml

  * `php_version` now defaults to `"7.1"` (was `"7.0"`).

### Improvements

  * #1252: Allow Drupal to be deployed into Drupal VM from a Git repository.
  * #1177: Add full and CI-tested support for Debian 8.
  * #1213: Add `DRUPALVM_ANSIBLE_TAGS` environment variable to specify tags to run.
  * #1031: Switch default PHP version to `7.1`.
  * #1211: Add mcrypt PHP extension on RedHat-based installs.
  * #1215: Document alternative method of running Drupal Console commands.
  * Removed logic supporting PHP 5.5, as it's no longer supported.
  * #1233: Tidy up the main Drupal VM playbook.
  * #1198: Use VAGRANT_HOME to get the SSH `insecure_private_key` directory for Drush.
  * #1238: Add a configurable intro message for `vagrant up` and `vagrant reload`.
  * #1230: Allow `Vagrantfile.local` to be either in project _or_ config directory.
  * #1244: Add support for a `secrets.yml` file for use with Ansible Vault.
  * #1135: Improve Sublime Text XDebug documentation.
  * Updated roles: Drush, Drupal, Firewall, Varnish.

### Bugfixes

  * #1199: Make sure `rsync` synced folders' `owner` and `group` are applied correctly.
  * #1212: Fixes Drush make builds after Drush role installation technique changed.
  * #1237: Raise a `VagrantError` for clearer error messaging.
  * #1220: Ensure `www-data` is in the group of the NFS synced directory (file permissions).
  * #1245: Ensure production `init.yml` playbook works on Ubuntu 16.04.
  * #1250: Document use of `DRUPALVM_ENV` variable in production docs.
  * #1253: Ensure `geerlingguy.php` role is run when `drupal` tag is used.


## 4.3.1 (2017-03-14)

### New/changed variables in default.config.yml

  * Removed now-unneccessary `drush_keep_updated` and `drush_composer_cli_options` vars.
  * Default to Drush version `8.1.10` (since we use the Phar-based install by default now).

### Improvements

  * #1197: Add PAReview.sh script setup to Drupal VM.
  * #1213: Add task-specific tags for supercharged reprovisioning.
  * #1212: Update Drush role and shave a minute or so off every build, ever!
  * #1215: Add docs on using Drupal Console with `vagrant exec`.
  * Update roles with bugfixes and improvements: Drush, Drupal.

### Bugfixes

  * #1211: Add mcrypt PHP extension on RedHat-based installs.


## 4.3.0 "Ring Game and Escape" (2017-03-09)

### Breaking Changes

  * No _explicit_ breaking changes; however, you should update any of the changed variables in the 'Updated Drupal-specific variable names' section below.

### New/changed variables in default.config.yml

  * `vagrant_gui: false` added (allows UI to appear after running `vagrant up` - Issue #1175).
  * Updated Drupal-specific variable names (Issue #1192):
    * `drupalvm_database` changed to `drupal_db_backend`
    * `build_makefile` changed to `drupal_build_makefile`
    * `build_composer` changed to `drupal_build_composer`
    * `build_composer_project` changed to `drupal_build_composer_project`
    * `install_site` changed to `drupal_install_site`
  * `drupal_core_owner` added (defaults to `drupalvm_user` - Issue #1192)
  * `tideways` added (commented out) to `installed_extras` (Issue #1181)

### Improvements

  * #1192: Move Drupal build and install code into revamped `geerlingguy.drupal` role.
  * #1175: Add `vagrant_gui` option to allow GUI to show when running `vagrant up`.
  * #1200: Only install necessary development packages (for faster, lighter builds).
  * Roles updated to latest version: Composer, Solr, Java, Selenium, Drush, Firewall, and Varnish.

### Bugfixes

  * #1167, #1181, #1168, #1188: Documentation tweaks.
  * #420: Update Drush role so 'run drush to set it up' doesn't fail.
  * #1182: Clean up Tideways documentation.


## 4.2.1 (2017-02-08)

### Improvements

  * Update Nginx, Java, Composer, and Selenium roles to latest version.

### Bugfixes

  * #1158: Fix Drupal 7 and Nginx breaking install.php access.
  * #1155: Fix failure installing Chrome on Ubuntu 14.04 (Selenium role).
  * #1151: PHP docs fix.


## 4.2.0 "Theme From Tron" (2017-01-30)

### Breaking Changes

  * N/A

### New/changed variables in default.config.yml

  * `apache_packages_state: latest` added to ensure latest Apache version is installed.
  * `firewall_disable_firewalld: true` and `firewall_disable_ufw: true` to ensure the system default firewalls are disabled on CentOS and Ubuntu, respectively (we set up our own rules, so this prevents weird problems).

### Improvements

  * #1123: Add Tideways support and updated documentation for use.
  * #1107: Allow additions to PHP packages via php_packages_extra.
  * #1092: Docs makeover.
  * #1134: Make Solr core work out of the box with Drupal 8 Search API Solr more easily.
  * #1110: Move `cron` example to the Docs.
  * #649: Document how to use `vagrant-lxc` with Drupal VM.
  * Update roles to latest versions: firewall, elasticsearch, nodejs, solr, nginx.

### Bugfixes

  * #1093: Upgrade Apache packages on provision so latest release is installed.
  * #1101: Update Selenium role so it works on systemd systems (e.g. Ubuntu 16.04, CentOS 7).
  * #1102: Update ruby role to add gem bin directory to `$PATH`.
  * #1131: Fixes solr < 5 on Ubuntu 16, CentOS 7 with Ansible 2.2.


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
