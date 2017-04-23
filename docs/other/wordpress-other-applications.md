While Drupal VM caters specifically to Drupal, and support for and compatibility with other PHP applications isn't guaranteed, Drupal VM is flexible enough to work with PHP applications besides Drupal.

## Wordpress

To integrate Drupal VM with an existing Wordpress project such as [bedrock](https://github.com/roots/bedrock), follow the documentation on using [Drupal VM as a Composer dependency](http://docs.drupalvm.com/en/latest/deployment/composer-dependency/).

Begin by forking/cloning `bedrock` as a boilerplate for your application, and require Drupal VM as a development dependency.

```yaml
composer require --dev geerlingguy/drupal-vm
```

Configure the VM by creating a `config/config.yml`:

```yaml
vagrant_hostname: bedrock.dev
vagrant_machine_name: bedrock

vagrant_synced_folders:
  - local_path: .
    destination: /var/www/wordpress
    type: nfs
    create: true

# Needs to match with what we have in .env and vagrant_synced_folders.
drupal_core_path: "/var/www/wordpress/web"
drupal_domain: "{{ vagrant_hostname }}"
drupal_db_user: wordpress
drupal_db_password: wordpress
drupal_db_name: wordpress

# Disable Drupal specific features.
drupal_build_composer_project: false
drupal_install_site: false
configure_drush_aliases: false

# Remove some Drupal extras such as `drupalconsole` and `drush`
installed_extras:
  - adminer
  - mailhog
  - pimpmylog

# Add wp-cli
composer_global_packages:
  - { name: hirak/prestissimo, release: '^0.3' }
  - { name: wp-cli/wp-cli, release: '^1.0.0' }
```

Create the delegating `Vagrantfile` in the root of the project:

```rb
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

Edit your `.env` file to match the values you set in `config/config.yml`:

```
DB_NAME=wordpress
DB_USER=wordpress
DB_PASSWORD=wordpress
DB_HOST=localhost

WP_ENV=development
WP_HOME=http://bedrock.dev
WP_SITEURL=${WP_HOME}/wp
```

Ignore local Drupal VM configuration files by adding the following to your `.gitignore`:

```
Vagrantfile.local
config/local.config.yml
```

Add a wp-cli `@dev` alias that points to the VM by editing the `wp-cli.yml` file:

```yaml
path: web/wp

@dev:
  ssh: vagrant@bedrock.dev/var/www/wordpress/web/wp
  url: bedrock.dev
```

For passwordless login with `wp-cli` add the following to your SSH config `~/.ssh/config`:

```
Host bedrock.dev
  StrictHostKeyChecking no
  IdentityFile ~/.vagrant.d/insecure_private_key
```

Provision the VM and import your database.

```sh
vagrant up
```
