Drupal VM's configuration works with multiple operating systems _and_ with multiple webservers. You can switch between Apache and Nginx (depending on which server you prefer) with ease. Apache is the webserver used out of the box.

You have complete control over all aspects of Apache VirtualHosts using the `apache_vhosts` configuration. A few simple examples are shown in `default.config.yml`, but this configuration can be much more complex.

See the examples included in the [`geerlingguy.apache` Ansible role's README](https://github.com/geerlingguy/ansible-role-apache#readme) for more info, as well as many other variables you can override to configure Apache exactly how you like it.

## Enable SSL Support with Apache

To enable SSL support for you virtual hosts you first need a certificate file. You can generate a self-signed certificate with a command like

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout example.key -out example.crt

_If you're using an actual production certificate you should of course **NOT** track it in git but transfer it to the VM before running `vagrant provision`_

Add the following to your `config.yml`:

```yaml
apache_vhosts_ssl:
  - servername: "{{ drupal_domain }}"
    documentroot: "{{ drupal_core_path }}"
    certificate_file: "/vagrant/example.crt"
    certificate_key_file: "/vagrant/example.key"
    extra_parameters: "{{ apache_vhost_php_fpm_parameters }}"
```

### Using Ubuntu's snakeoil certificate

If you are using Ubuntu as your base OS and you want to get started quickly with a local development environment you can use the snakeoil certificate that is already generated.

```yaml
apache_vhosts_ssl:
  - servername: "{{ drupal_domain }}"
    documentroot: "{{ drupal_core_path }}"
    certificate_file: "/etc/ssl/certs/ssl-cert-snakeoil.pem"
    certificate_key_file: "/etc/ssl/private/ssl-cert-snakeoil.key"
    extra_parameters: "{{ apache_vhost_php_fpm_parameters }}"
```
