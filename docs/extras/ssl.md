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
