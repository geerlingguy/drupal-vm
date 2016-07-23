# Ansible Role: Apache PHP-FPM

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-apache-php-fpm.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-apache-php-fpm)

An Ansible Role that configures Apache for PHP-FPM usage on RHEL/CentOS and Debian/Ubuntu.

## Requirements

This role is dependent upon `geerlingguy.apache`, and also requires you have PHP running with PHP-FPM somewhere on the server or elsewhere (I usually configure PHP with the `geerlingguy.php` role).

Additionally, this role will only work correctly if you have Apache 2.4.9+ installed; on older versions of Debian/Ubuntu Linux (e.g. 12.04), you can add `ppa:ondrej/apache2` prior to Apache installation to install Apache 2.4, for example:

    - name: Add repository for Apache 2.4 on Ubuntu 12.04.
      apt_repository: repo='ppa:ondrej/apache2'
      when: ansible_distribution_version == "12.04"

When configuring your Apache virtual hosts, you can add the following line to any vhost definition to enable passthrough to PHP-FPM:

    # If using a TCP port:
    ProxyPassMatch ^/(.*\.php(/.*)?)$ "fcgi://127.0.0.1:9000/var/www/example"
    
    # If using a Unix socket:
    ProxyPassMatch ^/(.*\.php(/.*)?)$ "unix:/var/run/php5-fpm.sock|fcgi://localhost/var/www/example"

For a full usage example with the `geerlingguy.apache` role, see the Example Playbook later in this README.

## Role Variables

None.

## Dependencies

None.

## Example Playbook

    - hosts: webservers
    
      vars:
        apache_vhosts:
          - servername: "www.example.com"
            documentroot: "/var/www/example"
            extra_parameters: |
                  ProxyPassMatch ^/(.*\.php(/.*)?)$ "fcgi://127.0.0.1:9000/var/www/example"
    
      roles:
        - { role: geerlingguy.apache }
        - { role: geerlingguy.php }
        - { role: geerlingguy.apache-fastcgi-php }

## License

MIT / BSD

## Author Information

This role was created in 2016 by [Jeff Geerling](http://jeffgeerling.com/), author of [Ansible for DevOps](http://www.ansiblefordevops.com/).
