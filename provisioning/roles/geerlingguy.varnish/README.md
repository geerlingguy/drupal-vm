# Ansible Role: Varnish

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-varnish.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-varnish)

Installs the [Varnish HTTP Cache](https://varnish-cache.org/) on RedHat/CentOS or Debian/Ubuntu Linux.

## Requirements

Requires the EPEL repository on RedHat/CentOS (you can install it using the `geerlingguy.repo-epel` role).

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    varnish_package_name: "varnish"

Varnish package name you want to install. See `apt-cache policy varnish` or `yum list varnish` for a listing of available candidates.

    varnish_version: "6.1"

Varnish version that should be installed. See the [Varnish Cache packagecloud.io repositories](https://packagecloud.io/varnishcache) for a listing of available versions. Some examples include: `6.1`, `6.0`, `5.1`, `4.1`, `3.0`, and `2.1`.

    varnish_config_path: /etc/varnish

The path in which Varnish configuration files will be stored.

    varnish_use_default_vcl: true

Whether to use the included (simplistic) default Varnish VCL, using the backend host/port defined with the next two variables. Set this to `false` and copy your own `default.vcl` file into the `varnish_config_path` if you'd like to use a more complicated setup. If this variable is set to `true`, all other configuration will be taken from Varnish's own [default VCL](https://www.varnish-cache.org/trac/browser/bin/varnishd/default.vcl?rev=3.0).

    varnish_default_vcl_template_path: default.vcl.j2

The default VCL file to be copied (if `varnish_use_default_vcl` is `true`). Defaults the the simple template inside `templates/default.vcl.j2`. This path should be relative to the directory from which you run your playbook.

    varnish_listen_port: "80"

The port on which Varnish will listen (typically port 80).

    varnish_default_backend_host: "127.0.0.1"
    varnish_default_backend_port: "8080"

Some settings for the default "default.vcl" template that will be copied to the `varnish_config_path` folder. The default backend host/port could be Apache or Nginx (or some other HTTP server) running on the same host or some other host (in which case, you might use port 80 instead).

    varnish_limit_nofile: 131072

The `nofiles` PAM limit Varnish will attempt to set for open files. The normal default is 1024 which is much too low for Varnish usage.

    varnish_secret: "14bac2e6-1e34-4770-8078-974373b76c90"

The secret/key to be used for connecting to Varnish's admin backend (for purge requests, etc.).

    varnish_admin_listen_host: "127.0.0.1"
    varnish_admin_listen_port: "6082"

The host and port through which Varnish will accept admin requests (like purge and status requests).

    varnish_storage: "file,/var/lib/varnish/varnish_storage.bin,256M"

How Varnish stores cache entries (this is passed in as the argument for `-s`). If you want to use in-memory storage, change to something like `malloc,256M`. Please read Varnish's [Getting Started guide](http://book.varnish-software.com/4.0/chapters/Getting_Started.html) for more information.

    varnish_pidfile: /run/varnishd.pid

Varnish PID file path. Set to an empty string if you don't want to use a PID file.

    varnishd_extra_options: ""

Extra options or flags to pass to the Varnish daemon when it starts (e.g. `-p http_max_hdr=128`).

    varnish_enabled_services:
      - varnish

Services that will be started at boot and should be running after this role is complete. You might need to add additional services if required, e.g. `varnishncsa` and `varnishlog`. If set to an empty array, no services will be enabled at startup.

    varnish_packagecloud_repo_yum_repository_priority: "1"

(RedHat/CentOS only) The `yum` priority for the Packagecloud repository used to install Varnish. Setting this explicitly forces yum to use the Packagecloud repositories to install Varnish even in environments (e.g. Amazon Linux) where other repositories may have higher priorities than the default.

    varnish_apt_repo: deb https://packagecloud.io/varnishcache/{{ varnish_packagecloud_repo }}/{{ ansible_distribution | lower }}/ {{ ansible_distribution_release }} main

(Debian/Ubuntu only) The `repo` for the apt repository.

    varnish_yum_repo_baseurl: https://packagecloud.io/varnishcache/{{ varnish_packagecloud_repo }}/el/{{ ansible_distribution_major_version|int }}/$basearch

(RedHat/CentOS only) The `baseurl` for the yum repository.

    varnish_backends:
      apache:
        host: 10.0.2.2
        port: 80
      nodejs:
        host: 10.0.2.3
        port: 80
    
    varnish_vhosts:
      example.com:
        backend: apache
      nodejs.example.com:
        backend: nodejs

You can configure multiple backends (and direct traffic from multiple virtual hosts to different backends) using the `varnish_backends` and `varnish_vhosts` variables. If you only use one backend (defined via `varnish_default_backend_host` and `varnish_default_backend_port`), then you do not need to define these variables. Do not add a `www` to the `vhosts` keys; it is added automatically by the `default.vcl.j2` VCL template.

## Dependencies

None.

## Example Playbook

    - hosts: webservers
      vars_files:
        - vars/main.yml
      roles:
        - geerlingguy.varnish

*Inside `vars/main.yml`*:

    varnish_secret: "[secret generated by uuidgen]"
    varnish_default_backend_port: 81
    ... etc ...

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
