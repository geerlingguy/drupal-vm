Drupal VM is configured to use `composer create-project` to build a Drupal 8 codebase by default but supports building Drupal from a custom composer.json or [Drush make file](drush-make.md).

## Using composer.json

1. Copy `example.drupal.composer.json` to `drupal.composer.json` and modify it to your liking.
2. Use the Composer build system by setting `build_composer: true` in your `config.yml` (make sure `build_makefile` and `build_composer_project` are set to `false`).
3. Configure `drupal_core_path` to point to the webroot directory: `drupal_core_path: {{ drupal_composer_install_dir }}/docroot`

```yaml
build_composer_project: false
build_composer: true
drupal_core_path: "{{ drupal_composer_install_dir }}/docroot"
```

_The file set in `drupal_composer_path` (which defaults to `drupal.composer.json`) will be copied from your host computer into the VM's `drupal_composer_install_dir` and renamed `composer.json`. If you already have a composer.json within that directory, set `drupal_composer_path: false`._

## Using Composer when [Drupal VM is a composer dependency itself](../other/drupalvm-composer-dependency.md)

In the scenario where you already have an existing `composer.json` in the root of your project, follow the usual steps for installing with a composer.json but instead of creating a `drupal.composer.json` file, disable the transfering of the file by setting `drupal_composer_path: false`, and change `drupal_composer_install_dir` to point to the the directory where it will be located. If `drupal_composer_path` is not truthy, Drupal VM assumes it already exists.

```yaml
build_composer_project: false
build_composer: true
drupal_composer_path: false
drupal_composer_install_dir: "/var/www/drupalvm"
drupal_core_path: "{{ drupal_composer_install_dir }}/docroot"
```

## Creating a project from a composer package: `composer create-project`

This is the default Drupal VM build configuration, set up by the following settings in `config.yml`:

  - Composer will build the project if `build_composer_project` is `true`, and `build_makefile` and `build_composer` are both `false`.
  - The Composer package is defined by `drupal_composer_project_package`.
  - Adjust the create-project CLI options in `drupal_composer_project_options` as well as add additional dependencies in `drupal_composer_dependencies`.
  - Ensure that the webroot configured in the Composer package matches the one set in `drupal_core_path`. The default is set to `web/`.

With [acquia/lightning-project](https://github.com/acquia/lightning-project) as an example your `config.yml` settings would be:

```yaml
drupal_composer_project_package: "acquia/lightning-project:^8.1.0"
drupal_composer_project_options: "--prefer-dist --stability rc --no-interaction"
drupal_core_path: "{{ drupal_composer_install_dir }}/docroot"
```

## Improving composer build performance

Opting for composer based installs will most likely increase your VM's time to provision considerably.

If you manage multiple VM's own your computer, you can use the [`vagrant-cachier` plugin](http://fgrehm.viewdocs.io/vagrant-cachier/) to share Composer's package cache across all VM's. The first build will be as slow as before but subsequent builds with the same `vagrant_box` (eg `geerlingguy/ubuntu1604`) will be much faster.

Install the plugin on your host computer: `vagrant plugin install vagrant-cachier`.

Drupal VM's `Vagrantfile` includes the appropriate `vagrant-cachier` configuration to cache Composer and apt dependencies.

_You can also use this plugin to share other package manager caches. For more information read the [documentation](http://fgrehm.viewdocs.io/vagrant-cachier/usage/)._
