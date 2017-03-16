[BigPipe](https://www.drupal.org/documentation/modules/big_pipe) is a Drupal module that was added as an 'experimental' module in Drupal 8.1. BigPipe allows PHP responses to be streamed in-progress so authenticated end users can recieve a cached response very quickly, with placeholders for more dynamic (harder to cache) content that are filled in during the same request.

To do this, BigPipe requires an environment configured to allow the authenticated request response to be streamed from PHP all the way through to the client. All parts of the web stack that intermediate the connection have to have output buffering disabled so the response stream can flow through.

Drupal VM's default configuration uses Apache with the `mod_proxy_fastcgi` module to connect to PHP-FPM, which isn't the most optimal configuration for BigPipe, and requires gzip compression to be disabled, so you should either switch to Nginx or consider further customizing the Apache configuration.

Drupal VM's Varnish configuration works with BigPipe out of the box, as it allows the backend response to be streamed whenever BigPipe is enabled (it outputs a `Surrogate-Control: BigPipe/1.0` header to tell Varnish when to stream the response).

## PHP configuration

BigPipe doesn't require any particular modifications to PHP in Drupal VM's default configuration. However, for some scenarios, you might want to disable php's `output_buffering` entirely by setting `php_output_buffering: "Off"` in `config.yml`, or change the `output_buffering` level from it's default of `4096` bytes.

## Nginx configuration

There is no extra configuration required to get BigPipe working with Nginx.

Nginx is the recommended way to use BigPipe, for the following reasons:

  - It's easier to configure Nginx to handle hundreds (or more) concurrent connections through to PHP-FPM than `mod_php`, and more widely used than the other compatible Apache CGI modules `mod_fcgid` and `mod_fastcgi`
  - Nginx intelligently disables output buffering and gzip if the `X-Accel-Buffering: no` header is present (BigPipe sets this header automatically). This means gzip and buffering can be enabled for most requests, and disabled on-the-fly by BigPipe.

## Apache configuration

Apache has three primary means of interacting with PHP applications like Drupal: `mod_php`, `mod_fastcgi`, and `mod_proxy_fcgi`. Drupal VM uses `mod_proxy_fcgi`, which is the most widely used and supported method of using Apache with PHP-FPM for the best scalability and memory management with Apache + PHP.

For all of these methods, you have to make sure `mod_deflate` gzip compression is disabled; you can do this by modifying the VirtualHost's `extra_parameters` parameter in the `apache_vhosts` list inside `config.yml`:

    apache_vhosts:
      - servername: "{{ drupal_domain }}"
        serveralias: "www.{{ drupal_domain }}"
        documentroot: "{{ drupal_core_path }}"
        extra_parameters: |
            {{ apache_vhost_php_fpm_parameters }}
            SetEnv no-gzip 1

This will disable the `mod_deflate` module for any requests inside that directory.

If you want to switch Apache to use `mod_php` instead of proxying requests through PHP-FPM, you can make the following changes in `config.yml`:

  1. Add `libapache2-mod-php7.1` to `extra_packages` in `config.yml`.
  2. Delete the `extra_parameters` under any Drupal site in the list of `apache_vhosts` (so there is no `SetHandler` rule).

You can also disable PHP-FPM and remove the two `proxy` entries from `apache_mods_enabled` if you don't want to use PHP-FPM with Apache at all, but that's optional; it won't break anything to run Apache with `mod_php` and `mod_proxy_fastcgi` at the same time.
