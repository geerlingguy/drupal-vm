[Varnish](https://www.varnish-software.com/) is an advanced reverse proxy and HTTP accelerator. At a basic level, it can act as a lightweight, very fast, and highly configurable static cache in front of your Drupal site. It also works as a load balancer and has some other tricks up it's sleeve, but for Drupal VM's purposes, you can think of it as a simple way to supercharge your site via proxy caching.

To enable Varnish, make sure `varnish` is in the list of your `installed_extras` in `config.yml`, and run `vagrant provision`.

There are a few varnish configuration variables further down in `example.config.yml` that you may wish to configure. You can use your own `.vcl` file template (instead of the generic Drupal 7-focused generic one) by editing the `varnish_default_vcl_template_path`, and you can use a different port for Varnish by changing `varnish_listen_port`.

If you'd like to use Varnish on port 80, and switch Apache to a different backend port, you can do so pretty easily; just make sure you have the following values set in your `config.yml` file, and run `vagrant provision` to have Ansible make the necessary changes:

```yaml
apache_listen_port: "81"

varnish_listen_port: "80"
varnish_default_backend_port: "81"
```

## Required Drupal Changes

In order for Varnish to actually do anything helpful (instead of just pass through requests and responses to/from the Apache backend), you need to set a few settings in Drupal:


  - On the `/admin/config/development/performance` page:
    - Check the 'Cache pages for anonymous users' setting (if it's not already enabled).
    - Set both the 'Minimum Cache Lifetime' and 'Expiration of cached pages' values to something reasonable (e.g. 5, 10, or 15 minutes—or much more if you don't update the content on the site much!).

You will also need to make a few small changes to your site's `settings.php` configuration to make Drupal work correctly behind a reverse proxy like Varnish:

```php
$conf['reverse_proxy'] = TRUE;
$conf['reverse_proxy_addresses'] = array('127.0.0.1');
```

If you don't set these values, Drupal will think all requests are coming from `127.0.0.1`. There are other settings you can change to make Drupal not store copies of cached pages in the Database (since Varnish is caching everything, this is redundant), but those other settings are not covered here.