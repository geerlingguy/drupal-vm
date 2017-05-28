For multisite installations, make the changes outlined in the [Local Drupal codebase](local-codebase.md) guide, but, using the `apache_vhosts` variable (or `nginx_vhosts` if using Nginx), configure as many domains pointing to the same docroot as you need:

```yaml
drupal_core_path: "/var/www/my-drupal-site"

...

apache_vhosts:
  # Drupal VM's default domain, evaluating to whatever `vagrant_hostname` is set to (drupalvm.dev by default).
  - servername: "{{ drupal_domain }}"
    serveralias: "www.{{ drupal_domain }}"
    documentroot: "{{ drupal_core_path }}"
    extra_parameters: "{{ apache_vhost_php_fpm_parameters }}"

  - servername: "local.second-drupal-site.com"
    documentroot: "{{ drupal_core_path }}"
    extra_parameters: "{{ apache_vhost_php_fpm_parameters }}"

  - servername: "local.third-drupal-site.com"
    documentroot: "{{ drupal_core_path }}"
    extra_parameters: "{{ apache_vhost_php_fpm_parameters }}"
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