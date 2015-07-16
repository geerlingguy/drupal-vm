For multisite installations, make the changes outlined in the [Local Drupal codebase](https://github.com/geerlingguy/drupal-vm/wiki/Local-Drupal-codebase) guide, but, using the `apache_vhosts` variable, configure as many domains pointing to the same docroot as you need:

```yaml
apache_vhosts:
  - {servername: "local.my-drupal-site.com", documentroot: "/var/www/my-drupal-site"}
  - {servername: "local.second-drupal-site.com", documentroot: "/var/www/my-drupal-site"}
  - {servername: "local.third-drupal-site.com", documentroot: "/var/www/my-drupal-site"}
  - {servername: "local.xhprof.com", documentroot: "/usr/share/php/xhprof_html"}
```

If you need additional databases and database users, add them to the list of `mysql_databases` and `mysql_users`:

```yaml
mysql_databases:
  - name: drupal
    encoding: utf8
    collation: utf8_general_ci
  - name: drupal_two
    encoding: utf8
    collation: utf8_general_ci

mysql_users:
  - name: drupal
    host: "%"
    password: drupal
    priv: "drupal.*:ALL"
  - name: drupal-two
    host: "%"
    password: drupal-two
    priv: "drupal_two.*:ALL"
```