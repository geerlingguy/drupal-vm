# Ansible Role: Nginx

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-nginx.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-nginx)

**Note:** Please consider using the official [NGINX Ansible role](https://github.com/nginxinc/ansible-role-nginx) from NGINX, Inc.

Installs Nginx on RedHat/CentOS, Debian/Ubuntu, Archlinux, FreeBSD or OpenBSD servers.

This role installs and configures the latest version of Nginx from the Nginx yum repository (on RedHat-based systems), apt (on Debian-based systems), pacman (Archlinux), pkgng (on FreeBSD systems) or pkg_add (on OpenBSD systems). You will likely need to do extra setup work after this role has installed Nginx, like adding your own [virtualhost].conf file inside `/etc/nginx/conf.d/`, describing the location and options to use for your particular website.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    nginx_vhosts: []

A list of vhost definitions (server blocks) for Nginx virtual hosts. Each entry will create a separate config file named by `server_name`. If left empty, you will need to supply your own virtual host configuration. See the commented example in `defaults/main.yml` for available server options. If you have a large number of customizations required for your server definition(s), you're likely better off managing the vhost configuration file yourself, leaving this variable set to `[]`.

    nginx_vhosts:
      - listen: "443 ssl http2"
        server_name: "example.com"
        server_name_redirect: "www.example.com"
        root: "/var/www/example.com"
        index: "index.php index.html index.htm"
        error_page: ""
        access_log: ""
        error_log: ""
        state: "present"
        template: "{{ nginx_vhost_template }}"
        filename: "example.com.conf"
        extra_parameters: |
          location ~ \.php$ {
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass unix:/var/run/php5-fpm.sock;
              fastcgi_index index.php;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              include fastcgi_params;
          }
          ssl_certificate     /etc/ssl/certs/ssl-cert-snakeoil.pem;
          ssl_certificate_key /etc/ssl/private/ssl-cert-snakeoil.key;
          ssl_protocols       TLSv1.1 TLSv1.2;
          ssl_ciphers         HIGH:!aNULL:!MD5;

An example of a fully-populated nginx_vhosts entry, using a `|` to declare a block of syntax for the `extra_parameters`.

Please take note of the indentation in the above block. The first line should be a normal 2-space indent. All other lines should be indented normally relative to that line. In the generated file, the entire block will be 4-space indented. This style will ensure the config file is indented correctly.

      - listen: "80"
        server_name: "example.com www.example.com"
        return: "301 https://example.com$request_uri"
        filename: "example.com.80.conf"

An example of a secondary vhost which will redirect to the one shown above.

*Note: The `filename` defaults to the first domain in `server_name`, if you have two vhosts with the same domain, eg. a redirect, you need to manually set the `filename` so the second one doesn't override the first one*

    nginx_remove_default_vhost: false

Whether to remove the 'default' virtualhost configuration supplied by Nginx. Useful if you want the base `/` URL to be directed at one of your own virtual hosts configured in a separate .conf file.

    nginx_upstreams: []

If you are configuring Nginx as a load balancer, you can define one or more upstream sets using this variable. In addition to defining at least one upstream, you would need to configure one of your server blocks to proxy requests through the defined upstream (e.g. `proxy_pass http://myapp1;`). See the commented example in `defaults/main.yml` for more information.

    nginx_user: "nginx"

The user under which Nginx will run. Defaults to `nginx` for RedHat, `www-data` for Debian and `www` on FreeBSD and OpenBSD.

    nginx_worker_processes: "{{ ansible_processor_vcpus|default(ansible_processor_count) }}"
    nginx_worker_connections: "1024"
    nginx_multi_accept: "off"

`nginx_worker_processes` should be set to the number of cores present on your machine (if the default is incorrect, find this number with `grep processor /proc/cpuinfo | wc -l`). `nginx_worker_connections` is the number of connections per process. Set this higher to handle more simultaneous connections (and remember that a connection will be used for as long as the keepalive timeout duration for every client!). You can set `nginx_multi_accept` to `on` if you want Nginx to accept all connections immediately.

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

    nginx_server_tokens: "on"

Nginx server_tokens settings. Controls whether nginx responds with it's version in HTTP headers. Set to `"off"` to disable.

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

See the template in `templates/nginx.conf.j2` for more details on the placement.

    nginx_extra_conf_options: ""

Extra lines to be inserted in the top of `nginx.conf`. The value should be defined literally (as you would insert it directly in the `nginx.conf`, adhering to the Nginx configuration syntax - such as `;` for line termination, etc.), for example:

    nginx_extra_conf_options: |
      worker_rlimit_nofile 8192;

See the template in `templates/nginx.conf.j2` for more details on the placement.

    nginx_log_format: |-
      '$remote_addr - $remote_user [$time_local] "$request" '
      '$status $body_bytes_sent "$http_referer" '
      '"$http_user_agent" "$http_x_forwarded_for"'

Configures Nginx's [`log_format`](http://nginx.org/en/docs/http/ngx_http_log_module.html#log_format). options.

    nginx_default_release: ""

(For Debian/Ubuntu only) Allows you to set a different repository for the installation of Nginx. As an example, if you are running Debian's wheezy release, and want to get a newer version of Nginx, you can install the `wheezy-backports` repository and set that value here, and Ansible will use that as the `-t` option while installing Nginx.

    nginx_ppa_use: false
    nginx_ppa_version: stable

(For Ubuntu only) Allows you to use the official Nginx PPA instead of the system's package. You can set the version to `stable` or `development`.

    nginx_yum_repo_enabled: true

(For RedHat/CentOS only) Set this to `false` to disable the installation of the `nginx` yum repository. This could be necessary if you want the default OS stable packages, or if you use Satellite.

    nginx_service_state: started
    nginx_service_enabled: yes

By default, this role will ensure Nginx is running and enabled at boot after Nginx is configured. You can use these variables to override this behavior if installing in a container or further control over the service state is required.

## Overriding configuration templates

If you can't customize via variables because an option isn't exposed, you can override the template used to generate the virtualhost configuration files or the `nginx.conf` file.

```yaml
nginx_conf_template: "nginx.conf.j2"
nginx_vhost_template: "vhost.j2"
```

If necessary you can also set the template on a per vhost basis.

```yaml
nginx_vhosts:
  - listen: "80 default_server"
    server_name: "site1.example.com"
    root: "/var/www/site1.example.com"
    index: "index.php index.html index.htm"
    template: "{{ playbook_dir }}/templates/site1.example.com.vhost.j2"
  - server_name: "site2.example.com"
    root: "/var/www/site2.example.com"
    index: "index.php index.html index.htm"
    template: "{{ playbook_dir }}/templates/site2.example.com.vhost.j2"
```

You can either copy and modify the provided template, or extend it with [Jinja2 template inheritance](http://jinja.pocoo.org/docs/2.9/templates/#template-inheritance) and override the specific template block you need to change.

### Example: Configure gzip in nginx configuration

Set the `nginx_conf_template` to point to a template file in your playbook directory.

```yaml
nginx_conf_template: "{{ playbook_dir }}/templates/nginx.conf.j2"
```

Create the child template in the path you configured above and extend `geerlingguy.nginx` template file relative to your `playbook.yml`.

```
{% extends 'roles/geerlingguy.nginx/templates/nginx.conf.j2' %}

{% block http_gzip %}
    gzip on;
    gzip_proxied any;
    gzip_static on;
    gzip_http_version 1.0;
    gzip_disable "MSIE [1-6]\.";
    gzip_vary on;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/x-javascript
        application/json
        application/xml
        application/xml+rss
        application/xhtml+xml
        application/x-font-ttf
        application/x-font-opentype
        image/svg+xml
        image/x-icon;
    gzip_buffers 16 8k;
    gzip_min_length 512;
{% endblock %}
```

## Dependencies

None.

## Example Playbook

    - hosts: server
      roles:
        - { role: geerlingguy.nginx }

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
