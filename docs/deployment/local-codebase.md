If you already have a Drupal codebase on your host machine (e.g. in `~/Sites/my-drupal-site`), and don't want or need to build your Drupal site with a Drush make file, make the following changes to `config.yml` before building Drupal VM:

## Sync your Drupal codebase to the VM

Update the `vagrant_synced_folders` configuration to sync your local Drupal codebase to a folder within the machine:

```yaml
vagrant_synced_folders:
  - local_path: ~/Sites/my-drupal-site
    destination: /var/www/my-drupal-site
    id: drupal
    type: nfs
```

## Disable the Drush make build and site install

Set `build_makefile` and `install_site` to `false`:

```yaml
build_makefile:: false
...
install_site: false
```

_If you aren't copying back a database, and want to have Drupal VM run `drush si` for your Drupal site, you can leave `install_site` set to `true` and it will run a site install on your Drupal codebase using the `drupal_*` config variables.

## Update `apache_vhosts`

Add your site to `apache_vhosts`, setting the `documentroot` to the same value as the `destination` of the synced folder you configured earlier:

```yaml
apache_vhosts:
  - {servername: "local.my-drupal-site.com", documentroot: "/var/www/my-drupal-site"}
  - {servername: "local.xhprof.com", documentroot: "/usr/share/php/xhprof_html"}
```

## Update MySQL info

If you have your Drupal site configured to use a special database and/or user/password for local development (e.g. through a `settings.local.php` file), you can update the values for `mysql_databases` and `mysql_users` as well.

## Build the VM, import your database

Run `vagrant up` to build the VM with your codebase synced into the proper location. Once the VM is created, you can connect to the MySQL database (see the sidebar topic "MySQL - Connecting to the DB") and import your site's database to the Drupal VM, or use a command like `drush sql-sync` to copy a database from another server.