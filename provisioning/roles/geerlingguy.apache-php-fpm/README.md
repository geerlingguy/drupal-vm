# Ansible Role: Apache PHP-FPM

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-apache-php-fpm.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-apache-php-fpm)

An Ansible Role that configures Apache for PHP-FPM usage on RHEL/CentOS and Debian/Ubuntu.

## Requirements

This role is dependent upon `geerlingguy.apache`, and also requires you have PHP running with PHP-FPM somewhere on the server or elsewhere (I usually configure PHP with the `geerlingguy.php` role).

When configuring your Apache virtual hosts, you can add the following line to any vhost definition to enable passthrough to PHP-FPM:

    # If using a TCP port:
    ProxyPassMatch ^/(.*\.php(/.*)?)$ "fcgi://127.0.0.1:9000/var/www/example"
    
    # If using a Unix socket:
    ProxyPassMatch ^/(.*\.php(/.*)?)$ "unix:/var/run/php5-fpm.sock|fcgi://localhost/var/www/example"

For a full usage example with the `geerlingguy.apache` role, see the Example Playbook later in this README.

### RedHat 6 and 7

RedHat/CentOS 7 automatically installs and enables mod_proxy_fcgi by default.

RedHat/CentOS 6 installs Apache 2.2, and is much harder to get configured with FastCGI, but here are two guides in case you need to support this use case:

  - [Apache 2.2 + mod_fastcgi](http://stackoverflow.com/a/21409702/100134)
  - [Apache 2.4 + mod_proxy_fcgi](http://unix.stackexchange.com/a/138903/16194

### Ubuntu < 14.04

This role will only work correctly if you have Apache 2.4.9+ installed; on older versions of Debian/Ubuntu Linux (e.g. 12.04), you can add `ppa:ondrej/apache2` prior to Apache installation to install Apache 2.4, for example:

    - name: Add repository for Apache 2.4 on Ubuntu 12.04.
      apt_repository: repo='ppa:ondrej/apache2'
      when: ansible_distribution_version == "12.04"

## Role Variables

None.

## Dependencies

None.

## Example Playbook

    - hosts: webservers
    
      vars:
        php_enable_php_fpm: true
        apache_vhosts:
          - servername: "www.example.com"
            documentroot: "/var/www/example"
            extra_parameters: |
                  ProxyPassMatch ^/(.*\.php(/.*)?)$ "fcgi://127.0.0.1:9000/var/www/example"
    
      roles:
        - geerlingguy.apache
        - geerlingguy.php
        - geerlingguy.apache-php-fpm

## License

MIT / BSD

## Author Information

This role was created in 2016 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](http://www.ansiblefordevops.com/).
