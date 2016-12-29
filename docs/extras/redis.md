[Redis](https://redis.io/) is an in-memory caching system, much like [Memcached](memcached.md). While [Varnish](varnish.md) is generally used to improve performance for anonymous users, `redis` is used to improve the performance for logged in users.

To enable Redis in Drupal VM, first make sure `redis` is in the list of `installed_extras` in your `config.yml`. Install the [Redis](https://www.drupal.org/project/redis) module and configure it as described in the [module's README](http://cgit.drupalcode.org/redis/tree/README.md).

For a list of available role variables, see the [`geerlingguy.redis` Ansible role's README](https://github.com/geerlingguy/ansible-role-redis#readme).
