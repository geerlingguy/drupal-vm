# Ansible Role: PHP-Tideways

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-php-tideways.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-php-tideways)

Installs the [Tideways PHP Profile Extension](https://github.com/tideways/php-profiler-extension) on Linux servers.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    workspace: /root

Where Tideways setup files will be downloaded and built.

    tideways_download_url: https://github.com/tideways/php-profiler-extension/archive/master.zip
    tideways_download_folder_name: php-profiler-extension-master

The URL from which Tideways will be downloaded.

    tideways_api_key: ''

If you use the Tideways UI, set this variable to your API key. Otherwise the extension can be used along with the XHProf UI to view profiles.

    tideways_install_xhprof_ui: yes

Tideways data-format is 100% compatible with XHProf so you can use the XHProf UI to browse profiles reports and the `XHProfRuns_Default` class to write the profile data to disk. If you use the Tideways UI, set this variable to `no`.

    xhprof_download_url: https://github.com/phacility/xhprof/archive/master.tar.gz
    xhprof_download_folder_name: xhprof-master

The URL from which XHProf will be downloaded.

    php_xhprof_lib_dir: /usr/share/php/xhprof_lib

Directory where the XHProf PHP library is stored.

    php_xhprof_html_dir: /usr/share/php/xhprof_html

Directory where the XHProf UI is stored.

## Dependencies

  - geerlingguy.php

## Example Playbook

    - hosts: webservers
      roles:
        - geerlingguy.php-tideways

## License

MIT / BSD

## Author Information

This role was created in 2017 by [Jeff Geerling](http://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
