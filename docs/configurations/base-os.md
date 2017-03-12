Drupal VM's configuration is designed to work with RedHat and Debian-compatible operating systems. Therefore, if you switch the `vagrant_box` in `config.yml` to any compatible OS, Drupal VM and all it's configuration should _Just Work™_... but that's not always the case.

Currently-supported OSes are:

  - Ubuntu 16.04 (default)
  - Ubuntu 14.04
  - Ubuntu 12.04
  - RedHat Enterprise Linux / CentOS 7
  - RedHat Enterprise Linux / CentOS 6

For certain OSes, there are a couple other caveats and tweaks you may need to perform to get things running smoothly—the main features and latest development is only guaranteed to work with the default OS as configured in `default.config.yml`.

Some other OSes should work, but are not regularly tested with Drupal VM, including Debian 8/Jessie (`debian/jessie64`) and Debian 7/Wheezy (`debian/wheezy64`).

## Ubuntu 16.04 Xenial LTS

Everything should work out of the box with Ubuntu 16.04.

## Ubuntu 14.04 Trusty LTS

Everything should work out of the box with Ubuntu 14.04.

## Ubuntu 12.04 Precise LTS

Everything should work out of the box with Ubuntu 12.04.

## RedHat Enterprise Linux / CentOS 7

Everything should work out of the box with RHEL 7.

## RedHat Enterprise Linux / CentOS 6

- **Apache without FastCGI**: If you want to use Apache with CentOS 6 on Drupal VM, you will need to modify the syntax of your `apache_vhosts` and remove the `extra_parameters: "{{ apache_vhost_php_fpm_parameters }}"` line from each one. Alternatively, you can use Nginx with the default configuration by setting `drupalvm_webserver: nginx` inside `config.yml`.

- **PHP OpCache**: PHP's OpCache (if you're using PHP > 5.5) requires the following setting to be configured in `config.yml` (see upstream bug: [CentOS (6) needs additional php-opcache package](https://github.com/geerlingguy/ansible-role-php/issues/39)):

```yaml
php_opcache_enabled_in_ini: false
```

- **Firewalld**: [Firewalld](http://www.firewalld.org/) is not available on CentOS 6, so the Drupal VM setting `firewall_disable_firewalld`, which defaults to `true`, must be overridden in `config.yml` and set to `false`:

```yaml
firewall_disable_firewalld: false
```
