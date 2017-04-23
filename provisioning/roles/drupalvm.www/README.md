# Drupal VM www Role

This role is a shim to configure miscellaneous settings prior to installing a Drupal site inside Drupal VM.

## Requirements

This role is meant to be run in Drupal VM. Use outside of Drupal VM will likely result in weird things happening.

## Role Variables

There are a few defaults defined, but you shouldn't really need to worry about this role's variables. It's a really simple role.

## Dependencies

  - geerlingguy.nginx if `drupalvm_webserver` is set to `nginx`.

## Example Playbook

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: drupalvm
      roles:
         - drupalvm.www

## License

MIT / BSD

## Author Information

This role was created in 2017 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
