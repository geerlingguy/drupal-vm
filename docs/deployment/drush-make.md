If you want to build a Drupal site using a [Drush make file](http://www.drush.org/en/master/make/) instead of Composer, you will need to do the following:

  - Set `drupal_build_composer_project: false`
  - Set `drupal_build_makefile: true`
  - Use the `example.drupal.make.yml` file as a base (copy it to a new file named `drupal.make.yml`), or use your own Drush make file
    - (You can also set a separate path to the makefile using the `drush_makefile_path` variable.)
  - Set the following options to force an install an older version of Drush (Drush 9+ no longer supports Drush make files):

```yaml
drush_launcher_install: no
drush_install_from_source: yes
drush_source_install_version: "8.1.15"
```

Have a look at the defaults in `default.config.yml` and tweak the settings as you'd like in your `config.yml`, then run `vagrant up` as in the Quick Start Guide. Within a few minutes, you should have your site running and available at the `drupal_domain` configured in `config.yml`, falling back to the default `http://drupalvm.test` set in `default.config.yml`.

With the default settings the Drupal site will be built on the VM inside `/var/www/drupalvm/drupal/web` but the `web/` subdirectory is only required for `composer` based projects and you can simplify this directory structure by setting `drupal_core_path` to `/var/www/drupalvm/drupal`.

```yaml
drupal_build_composer_project: false
drupal_build_makefile: true
drupal_core_path: "/var/www/drupalvm/drupal"
```
