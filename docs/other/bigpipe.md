[BigPipe](https://www.drupal.org/documentation/modules/big_pipe) is a Drupal module that was added as an 'experimental' module in Drupal 8.1. BigPipe allows PHP responses to be streamed in-progress so authenticated end users can recieve a cached response very quickly, with placeholders for more dynamic (harder to cache) content that are filled in during the same request.

To do this, BigPipe requires an environment configured to allow the authenticated request response to be streamed from PHP all the way through to the client. All parts of the web stack that intermediate the connection have to have output buffering disabled so the response stream can flow through.

Drupal VM's default configuration uses Apache's `mod_proxy_fastcgi` module, which doesn't allow output buffering to be disabled, so to use BigPipe with Drupal VM, you will need to either switch to Nginx or make a few modifications to the Apache configuration.

Drupal VM's Varnish configuration works with BigPipe out of the box, as it allows the backend response to be streamed whenever BigPipe is enabled (it outputs a `Surrogate-Control: BigPipe/1.0` header to tell Varnish when to stream the response).

## PHP configuration

BigPipe requires PHP's output buffering to be disabled. To do this, add the following line to `config.yml` with the other PHP configuration settings:

    php_output_buffering: "Off"

(You also need to make sure `zlib.output_compression` is `Off`—but that's the default, so you shouldn't need to change anything else in the PHP configuration).

## Nginx configuration

There is no extra configuration required to get BigPipe working with Nginx.

Nginx is the recommended way to use BigPipe, for the following reasons:

  - It's easier to configure Nginx to handle hundreds (or more) concurrent connections through to PHP-FPM than `mod_php`, and more widely used than the other compatible Apache CGI modules `mod_fcgid` and `mod_fastcgi`
  - Nginx intelligently disables output buffering and gzip if the `X-Accel-Buffering: no` header is present (BigPipe sets this header automatically). This means gzip and buffering can be enabled for most requests, and disabled on-the-fly by BigPipe.

## Apache configuration

There are a few ways you can configure Apache to work with a streamed response, but Drupal VM's default configuration uses `mod_proxy_fastcgi`, which is incompatible with BigPipe.

If you don't want to use Nginx (which requires no special configuration), you can switch Apache to use `mod_php` by making the following changes in `config.yml`:

  1. Add `libapache2-mod-php5` to `extra_packages` in `config.yml`.
  2. Delete the `extra_parameters` under any Drupal site in the list of `apache_vhosts` (so there is no `ProxyPassMatch` rule).

You can also disable PHP-FPM and remove the two `proxy` entries from `apache_mods_enabled` if you don't want to use PHP-FPM with Apache at all, but that's optional; it won't break anything to run Apache with `mod_php` and `mod_proxy_fastcgi` at the same time.
