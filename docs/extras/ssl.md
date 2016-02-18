To enable SSL support for you virtual hosts you first need a certificate file. You can generate a self-signed certificate with a command like

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout example.key -out example.crt

Place the files in your project directory and add the following to your `config.yml`.

```yaml
apache_vhosts_ssl:
  - servername: "{{ drupal_domain }}"
    documentroot: "{{ drupal_core_path }}"
    certificate_file: "/vagrant/example.crt"
    certificate_key_file: "/vagrant/example.key"
    extra_parameters: |
          ProxyPassMatch ^/(.*\.php(/.*)?)$ "fcgi://127.0.0.1:9000{{ drupal_core_path }}"
```

_If you're using an actual production certificate you should of course **NOT** track it in git but transfer it to the VM before running `vagrant provision`_

For a list of all configuration options see the [`geerlingguy.apache` Ansible role's README](https://github.com/geerlingguy/ansible-role-apache#readme).

### Using Ubuntu's snakeoil certificate

If you are using Ubuntu as your base OS and you want to get started quickly with a local development environment you can use the snakeoil certificate that is already generated.

```yaml
apache_vhosts_ssl:
  - servername: "{{ drupal_domain }}"
    documentroot: "{{ drupal_core_path }}"
    certificate_file: "/etc/ssl/certs/ssl-cert-snakeoil.pem"
    certificate_key_file: "/etc/ssl/private/ssl-cert-snakeoil.key"
    extra_parameters: |
          ProxyPassMatch ^/(.*\.php(/.*)?)$ "fcgi://127.0.0.1:9000{{ drupal_core_path }}"
```
