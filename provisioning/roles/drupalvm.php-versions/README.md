# Drupal VM PHP Versions Role

This role is a shim to configure miscellaneous settings prior to installing PHP inside Drupal VM.

## Requirements

This role is meant to be run in Drupal VM. Use outside of Drupal VM will likely result in weird things happening.

## Role Variables

The role has no default variables, but configures the `geerlingguy.php` role variables according to OS and PHP versions.

```yaml
php_version
```

The PHP version used. This variable does not have a default and thus needs to be set.

## Dependencies

- geerlingguy.php is a soft dependency as the `php_version` variable is required to be set.

## Example Playbook

    - hosts: drupalvm
      roles:
         - drupalvm.php-versions
         - geerlingguy.php

## License

MIT / BSD

## Author Information

This role was created in 2017 by [Oskar Schöldström](http://oxy.fi) and [Jeff Geerling](https://www.jeffgeerling.com/) (author of [Ansible for DevOps](https://www.ansiblefordevops.com/)).
