# Ansible Role: Nginx

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-nginx.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-nginx)

Installs Nginx on RedHat/CentOS or Debian/Ubuntu Linux, or FreeBSD servers.

This role installs and configures the latest version of Nginx from the Nginx yum repository (on RedHat-based systems) or via apt (on Debian-based systems) or pkgng (on FreeBSD systems). You will likely need to do extra setup work after this role has installed Nginx, like adding your own [virtualhost].conf file inside `/etc/nginx/conf.d/`, describing the location and options to use for your particular website.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    nginx_vhosts: []

A list of vhost definitions (server blocks) for Nginx virtual hosts. If left empty, you will need to supply your own virtual host configuration. See the commented example in `defaults/main.yml` for available server options. If you have a large number of customizations required for your server definition(s), you're likely better off managing the vhost configuration file yourself, leaving this variable set to `[]`.

    nginx_vhosts:
      - listen: "80 default_server"
        server_name: "example.com"
        root: "/var/www/example.com"
        index: "index.php index.html index.htm"
        error_page: ""
        access_log: ""
        error_log: ""
        extra_parameters: |
          location ~ \.php$ {
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:/var/run/php5-fpm.sock;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
          }

An example of a fully-populated nginx_vhosts entry, using a `|` to declare a block of syntax for the `extra_parameters`.

    nginx_remove_default_vhost: false

Whether to remove the 'default' virtualhost configuration supplied by Nginx. Useful if you want the base `/` URL to be directed at one of your own virtual hosts configured in a separate .conf file.

    nginx_vhosts_filename: "vhosts.conf"

The filename to use to store vhosts configuration. If you run the role multiple times (e.g. include the role with `with_items`), you can change the name for each run, effectively creating a separate vhosts file per vhost configuration.

    nginx_upstreams: []

If you are configuring Nginx as a load balancer, you can define one or more upstream sets using this variable. In addition to defining at least one upstream, you would need to configure one of your server blocks to proxy requests through the defined upstream (e.g. `proxy_pass http://myapp1;`). See the commented example in `defaults/main.yml` for more information.

    nginx_user: "nginx"

The user under which Nginx will run. Defaults to `nginx` for RedHat, and `www-data` for Debian.

    nginx_worker_processes: "1"
    nginx_worker_connections: "1024"
    nginx_multi_accept: "off"

`nginx_worker_processes` should be set to the number of cores present on your machine. Connections (find this number with `grep processor /proc/cpuinfo | wc -l`). `nginx_worker_connections` is the number of connections per process. Set this higher to handle more simultaneous connections (and remember that a connection will be used for as long as the keepalive timeout duration for every client!). You can set `nginx_multi_accept` to `on` if you want Nginx to accept all connections immediately.

    nginx_error_log: "/var/log/nginx/error.log warn"
    nginx_access_log: "/var/log/nginx/access.log main buffer=16k"

Configuration of the default error and access logs. Set to `off` to disable a log entirely.

    nginx_sendfile: "on"
    nginx_tcp_nopush: "on"
    nginx_tcp_nodelay: "on"

TCP connection options. See [this blog post](https://t37.net/nginx-optimization-understanding-sendfile-tcp_nodelay-and-tcp_nopush.html) for more information on these directives.

    nginx_keepalive_timeout: "65"
    nginx_keepalive_requests: "100"

Nginx keepalive settings. Timeout should be set higher (10s+) if you have more polling-style traffic (AJAX-powered sites especially), or lower (<10s) if you have a site where most users visit a few pages and don't send any further requests.

    nginx_client_max_body_size: "64m"

This value determines the largest file upload possible, as uploads are passed through Nginx before hitting a backend like `php-fpm`. If you get an error like `client intended to send too large body`, it means this value is set too low.

    nginx_server_names_hash_bucket_size: "64"

If you have many server names, or have very long server names, you might get an Nginx error on startup requiring this value to be increased.

    nginx_proxy_cache_path: ""

Set as the `proxy_cache_path` directive in the `nginx.conf` file. By default, this will not be configured (if left as an empty string), but if you wish to use Nginx as a reverse proxy, you can set this to a valid value (e.g. `"/var/cache/nginx keys_zone=cache:32m"`) to use Nginx's cache (further proxy configuration can be done in individual server configurations).

    nginx_extra_http_options: ""

Extra lines to be inserted in the top-level `http` block in `nginx.conf`. The value should be defined literally (as you would insert it directly in the `nginx.conf`, adhering to the Nginx configuration syntax - such as `;` for line termination, etc.), for example:

    nginx_extra_http_options: |
      proxy_buffering    off;
      proxy_set_header   X-Real-IP $remote_addr;
      proxy_set_header   X-Scheme $scheme;
      proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header   Host $http_host;

    nginx_default_release: ""

(For Debian/Ubuntu only) Allows you to set a different repository for the installation of Nginx. As an example, if you are running Debian's wheezy release, and want to get a newer version of Nginx, you can install the `wheezy-backports` repository and set that value here, and Ansible will use that as the `-t` option while installing Nginx.

    nginx_ppa_use: false
    nginx_ppa_version: stable

(For Ubuntu only) Allows you to use the official Nginx PPA instead of the system's package. You can set the version to `stable` or `development`.

## Dependencies

None.

## Example Playbook

    - hosts: server
      roles:
        - { role: geerlingguy.nginx }

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](http://jeffgeerling.com/), author of [Ansible for DevOps](http://ansiblefordevops.com/).
