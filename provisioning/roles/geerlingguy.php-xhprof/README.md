# Ansible Role: PHP-XHProf

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-php-xhprof.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-php-xhprof)

Installs PHP [XHProf](http://php.net/manual/en/book.xhprof.php) on Linux servers.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    workspace: /root

Where XHProf setup files will be downloaded and built.

    xhprof_download_url: https://github.com/RustJason/xhprof/archive/php7.zip
    xhprof_download_folder_name: xhprof-php7

The URL from which XHProf will be downloaded. Note that this default is for the PHP 7-compatible version of XHProf. If you're using PHP 5.x, you should probably switch to the 'official' upstream source: `https://github.com/phacility/xhprof/archive/master.tar.gz`.

    xhprof_output_dir: /tmp

Directory where XHProf runs are stored.

    php_xhprof_lib_dir: /usr/share/php/xhprof_lib

Directory where the XHProf PHP library is stored.

    php_xhprof_html_dir: /usr/share/php/xhprof_html

Directory where the XHProf UI is stored.

## Dependencies

  - geerlingguy.php

## Example Playbook

    - hosts: webservers
      roles:
        - { role: geerlingguy.php-xhprof }

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](http://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
