To make future Drupal VM updates easier to integrate with an existing project, you might consider the more complex setup of installing Drupal VM as a `composer` dependency. Using a delegating `Vagrantfile` you are able to run `vagrant` commands anywhere in your project as well as separate your custom configuration files from Drupal VM's own files.

### Add Drupal VM as a Composer dependency

Add Drupal VM as a development dependency to your `composer.json`.

```
composer require --dev geerlingguy/drupal-vm
```

### Setup your configuration files

Add and configure the `config.yml` anywhere you like, in this example we place it in a `config/` directory.

_Note: This will be the directory where Drupal VM looks for other local configuration files as well. Such as `drupal_build_makefile` and `local.config.yml`._

```
├── composer.json
├── config/
│   ├── config.yml
│   ├── local.config.yml
│   └── Vagrantfile.local
├── docroot/
│   ├── ...
│   └── index.php
└── vendor/
    ├── ...
    └── geerlingguy/
        └── drupal-vm/
```

Change the [build strategy to use your `composer.json`](composer.md#using-composer-when-drupal-vm-is-a-composer-dependency-itself) file by setting:

```yaml
drupal_build_composer_project: false
drupal_build_composer: true
drupal_composer_path: false
drupal_composer_install_dir: "/var/www/drupalvm"
drupal_core_path: "{{ drupal_composer_install_dir }}/docroot"
```

If you intened to use the devel module, it must be added as a requirement to your `composer.json` file. Alternatively, if you do not intend to use it remove it from `drupal_enabled_modules` in your `config.yml` file:

```yaml
drupal_enabled_modules: []
```

### Create a delegating `Vagrantfile`

Create a delegating `Vagrantfile` that will catch all your `vagrant` commands and send them to Drupal VM's own `Vagrantfile`. Place this file in your project's root directory.

```ruby
# The absolute path to the root directory of the project. Both Drupal VM and
# the config file need to be contained within this path.
ENV['DRUPALVM_PROJECT_ROOT'] = "#{__dir__}"
# The relative path from the project root to the config directory where you
# placed your config.yml file.
ENV['DRUPALVM_CONFIG_DIR'] = "config"
# The relative path from the project root to the directory where Drupal VM is located.
ENV['DRUPALVM_DIR'] = "vendor/geerlingguy/drupal-vm"

# Load the real Vagrantfile
load "#{__dir__}/#{ENV['DRUPALVM_DIR']}/Vagrantfile"
```

When you issue `vagrant` commands anywhere in your project tree this file will be detected and used as a delegator for Drupal VM's own Vagrantfile.

Your project structure should now look like this:

```
├── Vagrantfile
├── composer.json
├── config/
│   ├── config.yml
│   ├── local.config.yml
│   └── Vagrantfile.local
├── docroot/
│   ├── ...
│   └── index.php
└── vendor/
    ├── ...
    └── geerlingguy/
        └── drupal-vm/
```

### Provision the VM

Finally provision the VM using the delegating `Vagrantfile`.

```sh
vagrant up
```

_Important: you should never issue `vagrant` commands through Drupal VM's own `Vagrantfile` from now on. If you do, it will create a secondary VM in that directory._

## Drupal VM in a subdirectory without composer

If you're not using `composer` in your project you can still download  Drupal VM (or add it as a git submodule) to any subdirectory in your project. As an example let's name that directory `box/`.

```
├── docroot/
│   ├── ...
│   └── index.php
└── box/
    ├── ...
    ├── default.config.yml
    └── Vagrantfile
```

Configure your `config.yml` as mentioned in the [`composer` section](#setup-your-configuration-files) above.

```yaml
post_provision_scripts:
  # The default provided in `default.config.yml`:
  - "../../examples/scripts/configure-solr.sh"
  # With Drupal VM in a toplevel subdirectory
  - "{{ config_dir }}/../examples/scripts/configure-solr.sh"
```

Your directory structure should now look like this:

```
├── Vagrantfile
├── config/
│   ├── config.yml
│   ├── local.config.yml
│   └── Vagrantfile.local
├── docroot/
│   ├── ...
│   └── index.php
└── box/
    ├── ...
    ├── default.config.yml
    └── Vagrantfile
```

Provision the VM using the delegating `Vagrantfile`.

```sh
vagrant up
```
