Drupal VM is configured to use `composer create-project` to build a Drupal 8 codebase by default but supports building Drupal from a custom `composer.json` file as well.

_Note that if you already have a project built using a `composer.json` file you should instead add [Drupal VM as a dependency](composer-dependency.md) of your project. The method described below will make it somewhat difficult to manage your `composer.json` together with Drupal VM as the file will be copied from `drupal_composer_path` into `drupal_composer_install_dir` as a secondary `composer.json`._

1. Copy `example.drupal.composer.json` to `drupal.composer.json` and modify it to your liking.
2. Use the Composer build system by setting `drupal_build_composer: true` in your `config.yml` (make sure `drupal_build_makefile` and `drupal_build_composer_project` are set to `false`).
3. Ensure `drupal_core_path` points to the webroot directory: `drupal_core_path: {{ drupal_composer_install_dir }}/web`

```yaml
drupal_build_makefile: false
drupal_build_composer_project: false
drupal_build_composer: true
drupal_core_path: "{{ drupal_composer_install_dir }}/web"
```

The file set in `drupal_composer_path` (which defaults to `drupal.composer.json`) will be copied from your host computer into the VM's `drupal_composer_install_dir` and renamed `composer.json`.

_Opting for composer based installs will most likely increase your VM's time to provision considerably. Find out how you can [improve composer build performance](../other/performance.md#improving-composer-build-performance)._
