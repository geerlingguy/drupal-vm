If you're setting up a new project you can get up and running quickly using [drupal-composer/drupal-project](https://github.com/drupal-composer/drupal-project) as a project template.

```sh
composer create-project drupal-composer/drupal-project:8.x-dev <some-dir> --stability dev --no-interaction
```

### Add Drupal VM as a Composer dependency

Require Drupal VM as a development dependency to your project.

    composer require --dev geerlingguy/drupal-vm

_This command will scaffold a `Vagrantfile` in the root of your project. Feel free to add it to your `.gitignore` as the file is now managed by Drupal VM and will be reset each time you run `composer update`._

### Create a `config.yml` to configure the VM

Create and configure a config.yml file, eg. in `vm/config.yml`. You'll need at least the following variables:

    # Change the build strategy to use a composer.json file.
    drupal_build_composer: true
    drupal_build_composer_project: false

    # Tell Drupal VM that the composer.json file already exists and doesn't need to be transfered.
    drupal_composer_path: false

    # Set the location of the composer.json file and Drupal core.
    drupal_composer_install_dir: "/var/www/drupalvm"
    drupal_core_path: "{{ drupal_composer_install_dir }}/web"

_Note that `drupal_core_path` needs to match your `composer.json` configuration. `drupal-project` uses `web/` whereas Lightning and BLT uses `docroot/`_

If you placed the `config.yml` file in a subdirectory, tell Drupal VM where by adding the location to your `composer.json`. If not, Drupal VM will look for all configuration files in the root of your project.

    composer config extra.drupalvm.config_dir 'vm'

## Patching Drupal VM

If you need to patch something in Drupal VM that you're otherwise unable to configure, you can do so with the help of the `composer-patches` plugin. Read the [documentation on how to create and apply patches](../extending/patching.md).
