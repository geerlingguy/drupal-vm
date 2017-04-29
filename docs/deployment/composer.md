Drupal VM is configured to use `composer create-project` to build a Drupal 8 codebase by default but supports building Drupal from a custom `composer.json` file as well.

1. Copy `example.drupal.composer.json` to `drupal.composer.json` and modify it to your liking.
2. Use the Composer build system by setting `drupal_build_composer: true` in your `config.yml` (make sure `drupal_build_makefile` and `drupal_build_composer_project` are set to `false`).
3. Ensure `drupal_core_path` points to the webroot directory: `drupal_core_path: {{ drupal_composer_install_dir }}/web`

```yaml
drupal_build_makefile: false
drupal_build_composer_project: false
drupal_build_composer: true
drupal_core_path: "{{ drupal_composer_install_dir }}/web"
```

_The file set in `drupal_composer_path` (which defaults to `drupal.composer.json`) will be copied from your host computer into the VM's `drupal_composer_install_dir` and renamed `composer.json`._

## Using Composer when [Drupal VM is a composer dependency itself](composer-dependency.md)

In the scenario where you have an existing `composer.json` in the root of your project, follow the usual steps for installing with a composer.json but instead of creating a `drupal.composer.json` file, disable the transfering of the file by setting `drupal_composer_path: false`, and change `drupal_composer_install_dir` to point to the the directory where it will be located. If `drupal_composer_path` is not truthy, Drupal VM assumes it already exists.

```yaml
drupal_build_composer_project: false
drupal_build_composer: true
drupal_composer_path: false
drupal_composer_install_dir: "/var/www/drupalvm"
drupal_core_path: "{{ drupal_composer_install_dir }}/docroot"
```

_Opting for composer based installs will most likely increase your VM's time to provision considerably. Find out how you can [improve composer build performance](../other/performance.md#improving-composer-build-performance)._
