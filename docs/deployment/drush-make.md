Drupal VM is configured by default to use a Drush make file to build a Drupal site on the VM inside `/var/www/drupalvm/drupal` (in a folder that's synced to your local machine, so you can work with the Drupal codebase either locally or inside the VM).

You can use any make file you want, just copy it or symlink it into the root of the Drupal VM folder with the filename `drupal.make.yml`. You can also set a separate path to the makefile using the `drush_makefile_path` variable.

Have a look at the defaults in `default.config.yml` and tweak the settings as you'd like in your `config.yml`, then run `vagrant up` as in the Quick Start Guide. Within a few minutes, you should have your site running and available at the `drupal_domain` configured in `config.yml`, falling back to the default `http://drupalvm.dev` set in `default.config.yml`.
