Drupal VM is configured to use [Drush make](drush-make.md) by default but supports building Drupal from a custom composer.json or creating a project from a composer package (`composer create-project`).

## Using composer.json

1. Copy `example.drupal.composer.json` to `drupal.composer.json` and modify it to your liking.
2. Switch the build system by setting `build_makefile: false` and `build_composer: true` in your `config.yml`.
3. Configure `drupal_core_path` to point to the webroot directory: `drupal_core_path: {{ drupal_composer_install_dir }}/docroot`

```yaml
build_makefile: false
build_composer: true
drupal_core_path: "{{ drupal_composer_install_dir }}/docroot"
```

_The file set in `drupal_composer_path` (which defaults to `drupal.composer.json`) will be copied from your host computer into the VM's `drupal_composer_install_dir` and renamed `composer.json`. If you already have a composer.json within that directory, you can set `drupal_composer_path: false`._

## Using Composer when [Drupal VM is a composer dependency itself](../other/drupalvm-composer-dependency.md)

In the scenario where you already have an existing `composer.json` in the root of your project, follow the usual steps for installing with a composer.json but instead of creating a `drupal.composer.json` file, disable the transfering of the file by setting `drupal_composer_path` to `false`, and change `drupal_composer_install_dir` to point to the the directory where it will be located. If `drupal_composer_path` is not truthy, Drupal VM assumes it already exists.

```yaml
build_makefile: false
build_composer: true
drupal_composer_path: false
drupal_composer_install_dir: "/var/www/drupalvm"
drupal_core_path: "{{ drupal_composer_install_dir }}/docroot"
```

## Creating a project from a composer package: `composer create-project`

There's a couple of things you need to configure in your `config.yml`:

- Switch the build system by setting `build_makefile: false`, `build_composer: false` and `build_composer_project: true`.
- Configure the composer package in `drupal_composer_project_package`.
- Additionally you can adjust the create-project CLI options in `drupal_composer_project_options` as well as add additional dependencies in `drupal_composer_dependencies`.
- Ensure that the webroot configured in the composer package matches the one set in `drupal_core_path`.

With [drupal-composer/drupal-project](https://github.com/drupal-composer/drupal-project) as an example your `config.yml` overrides would be:

```yaml
build_makefile: false
build_composer: false
build_composer_project: true

drupal_composer_project_package: "drupal-composer/drupal-project:8.x-dev"
# Added `--no-dev` to avoid installing development dependencies.
drupal_composer_project_options: "--prefer-dist --stability dev --no-interaction --no-dev"
drupal_composer_dependencies:
  - "drupal/devel:8.*"

drupal_core_path: "{{ drupal_composer_install_dir }}/web"
```

## Improving composer build performance

Opting for composer based installs will most likely increase your VM's time to provision considerably.

If you manage multiple VM's own your computer, you can use the [`vagrant-cachier` plugin](http://fgrehm.viewdocs.io/vagrant-cachier/) to share Composer's package cache across all VM's. The first build will be as slow as before but subsequent builds with the same `vagrant_box` (eg `geerlingguy/ubuntu1604`) will be much faster.

1. Install the plugin on your host computer: `vagrant plugin install vagrant-cachier`
2. Create a `Vagrantfile.local` next to your `config.yml` with the following:

```rb
config.cache.scope = :box
config.cache.auto_detect = false
config.cache.enable :generic, { :cache_dir => "/home/vagrant/.composer/cache"  }
```

_Note: Out of the box, sharing the Composer cache is not supported as the plugin requires PHP to be installed when the VM first boots up. This is why the generic cache bucket is used instead._

_You can also use this plugin to share other package manager caches. For more information read the [documentation](http://fgrehm.viewdocs.io/vagrant-cachier/usage/)._
