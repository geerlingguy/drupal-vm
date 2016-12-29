To enable SSL support for you virtual hosts you first need a certificate file. You can generate a self-signed certificate with a command like

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout example.key -out example.crt

Place the files in your project directory and edit your `config.yml`.

_If you're using an actual production certificate you should of course **NOT** track it in git but transfer it to the VM before running `vagrant provision`_

### Apache

Add the following to your `config.yml`:

```yaml
apache_vhosts_ssl:
  - servername: "{{ drupal_domain }}"
    documentroot: "{{ drupal_core_path }}"
    certificate_file: "/vagrant/example.crt"
    certificate_key_file: "/vagrant/example.key"
    extra_parameters: "{{ apache_vhost_php_fpm_parameters }}"
```

For a list of all configuration options see the [`geerlingguy.apache` Ansible role's README](https://github.com/geerlingguy/ansible-role-apache#readme).

### Nginx

Modify your nginx host configuration by adding the following `extra_parameters` to the first entry in `nginx_hosts`:

```yaml
- server_name: "{{ drupal_domain }} www.{{ drupal_domain }}"
  root: "{{ drupal_core_path }}"
  is_php: true
  extra_parameters: |
        listen 443 ssl;
        ssl_certificate     /vagrant/example.crt;
        ssl_certificate_key /vagrant/example.key;
        ssl_protocols       TLSv1.1 TLSv1.2;
        ssl_ciphers         HIGH:!aNULL:!MD5;
```

For a list of all configuration options see the [`geerlingguy.nginx` Ansible role's README](https://github.com/geerlingguy/ansible-role-nginx#readme).

## Using Ubuntu's snakeoil certificate

If you are using Ubuntu as your base OS and you want to get started quickly with a local development environment you can use the snakeoil certificate that is already generated.

#### Apache

```yaml
apache_vhosts_ssl:
  - servername: "{{ drupal_domain }}"
    documentroot: "{{ drupal_core_path }}"
    certificate_file: "/etc/ssl/certs/ssl-cert-snakeoil.pem"
    certificate_key_file: "/etc/ssl/private/ssl-cert-snakeoil.key"
    extra_parameters: "{{ apache_vhost_php_fpm_parameters }}"
```

#### Nginx

```yaml
- server_name: "{{ drupal_domain }} www.{{ drupal_domain }}"
  root: "{{ drupal_core_path }}"
  is_php: true
  extra_parameters: |
        listen 443 ssl;
        ssl_certificate     /etc/ssl/certs/ssl-cert-snakeoil.pem;
        ssl_certificate_key /etc/ssl/private/ssl-cert-snakeoil.key;
        ssl_protocols       TLSv1.1 TLSv1.2;
        ssl_ciphers         HIGH:!aNULL:!MD5;
```

## Tips & Tricks

To automatically add a SSL virtual host for every Apache host defined in `apache_vhosts` you can add the following to your `config.yml`:

```yaml
apache_vhost_ssl_parameters:
  certificate_file: "/etc/ssl/certs/ssl-cert-snakeoil.pem"
  certificate_key_file: "/etc/ssl/private/ssl-cert-snakeoil.key"

# Generate a SSL virtual host for every regular vhost.
apache_vhosts_ssl: "{% set vhosts = [] %}{% for vhost in apache_vhosts %}{% if vhosts.append(vhost|combine(apache_vhost_ssl_parameters)) %}{% endif %}{% endfor %}{{ vhosts }}"
```
