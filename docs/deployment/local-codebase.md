If you already have a Drupal codebase on your host machine (e.g. in `~/Sites/my-drupal-site`), and don't want or need to build your Drupal site with a Drush make file, make the following changes to `config.yml` before building Drupal VM:

## Sync your Drupal codebase to the VM

Update the `vagrant_synced_folders` configuration to sync your local Drupal codebase to a folder within the machine:

```yaml
vagrant_synced_folders:
  - local_path: ~/Sites/my-drupal-site
    destination: /var/www/my-drupal-site
    type: nfs
```

_If you have Drupal VM installed within your codebase, you can also set the `local_path` to a location relative to the `Vagrantfile`. This is the default setup in `default.config.yml`._

## Disable the Composer project build and site install

Set all the `drupal_build_*` variables and `install_site` to `false`:

```yaml
drupal_build_makefile: false
drupal_build_composer: false
drupal_build_composer_project: false
...
drupal_install_site: false
```

If you aren't copying back a database, and want to have Drupal VM run `drush si` for your Drupal site, you can leave `drupal_install_site` set to `true` and it will run a site install on your Drupal codebase using the `drupal_*` config variables.

## Update `drupal_core_path`

Set `drupal_core_path` to the same value as the `destination` of the synced folder you configured earlier:

```yaml
drupal_core_path: "/var/www/my-drupal-site"
```

This variable will be used for the document root of the webserver.

## Set the domain

By default the domain of your site will be `drupalvm.dev` but you can change it by setting `drupal_domain` to the domain of your choice:

```yaml
drupal_domain: "local.my-drupal-site.com"
```

If you prefer using your domain as the root of all extra packages installed, ie. `adminer`, `xhprof` and `pimpmylog`, set it as the value of `vagrant_hostname` instead.

```yaml
vagrant_hostname: "my-drupal-site.com"
drupal_domain: "{{ vagrant_hostname }}"
```

## Update MySQL info

If you have your Drupal site configured to use a special database and/or user/password for local development (e.g. through a `settings.local.php` file), you can update the values for `mysql_databases` and `mysql_users` as well.

## Build the VM, import your database

Run `vagrant up` to build the VM with your codebase synced into the proper location. Once the VM is created, you can [connect to the MySQL database](../configurations/databases-mysql.md) and import your site's database to the Drupal VM, or use a [command like `drush sql-sync`](../extras/drush.md#using-sql-sync) to copy a database from another server.
