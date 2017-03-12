[Redis](https://redis.io/) is an in-memory caching system, much like [Memcached](memcached.md). While [Varnish](varnish.md) is generally used to improve performance for anonymous users, `redis` is used to improve the performance for logged in users.

To enable Redis in Drupal VM:

1. Make sure `redis` is in the list of `installed_extras` in your `config.yml`.
2. Install the [Redis](https://www.drupal.org/project/redis) module.
3. Enable the module before you configure it in the next step.
4. Add the following to your `settings.php`

```php
// Make redis the default cache class.
$settings['cache']['default'] = 'cache.backend.redis'
```

There's a lot more configuration available and the best resource is generally the [Redis module's README](http://cgit.drupalcode.org/redis/tree/README.md).

For a list of available role variables, see the [`geerlingguy.redis` Ansible role's README](https://github.com/geerlingguy/ansible-role-redis#readme).
