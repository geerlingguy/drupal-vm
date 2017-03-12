Out of the box Drupal VM is configured to use `composer create-project` to build a Drupal 8 codebase.

This is set up with the following variables in `config.yml`:

  - Composer will build the project if `drupal_build_composer_project` is `true`, and `drupal_build_makefile` and `drupal_build_composer` are both `false`.
  - The Composer package is defined by `drupal_composer_project_package`.
  - Adjust the create-project CLI options in `drupal_composer_project_options` as well as add additional dependencies in `drupal_composer_dependencies`.
  - Ensure that the webroot configured in the Composer package matches the one set in `drupal_core_path`. The default is set to `web/`.

With [acquia/lightning-project](https://github.com/acquia/lightning-project) as an example your `config.yml` settings would be:

```yaml
drupal_composer_project_package: "acquia/lightning-project:^8.1.0"
drupal_composer_project_options: "--prefer-dist --stability rc --no-interaction"
drupal_core_path: "{{ drupal_composer_install_dir }}/docroot"
```

_Opting for composer based installs will most likely increase your VM's time to provision considerably. Find out how you can [improve composer build performance](../other/performance.md#improving-composer-build-performance)._
