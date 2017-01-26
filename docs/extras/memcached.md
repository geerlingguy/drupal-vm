[Memcached](https://memcached.org/) is an in-memory caching system, much like [Redis](redis.md). While [Varnish](varnish.md) is generally used to improve performance for anonymous users, `memcached` is used to improve the performance for logged in users.

To enable Memcached in Drupal VM:

1. Make sure `memcached` is in the list of `installed_extras` in your `config.yml`.
2. Install the [Memcache API](https://www.drupal.org/project/memcache) module.
3. Enable the module before you configure it in the next step.
4. Add the following to your `settings.php`

```php
// Make memcache the default cache class.
$settings['cache']['default'] = 'cache.backend.memcache';
```

There's a lot more configuration available and the best resource is generally the [Memcache API module's README](http://cgit.drupalcode.org/memcache/tree/README.txt?h=8.x-2.x).

For a list of available role variables, see the [`geerlingguy.memcached` Ansible role's README](https://github.com/geerlingguy/ansible-role-memcached#readme).
