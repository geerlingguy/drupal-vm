# Drupal VM hostname Role

This role is a shim to set the hostname and FQDN of Drupal VM.

## Requirements

This role is meant to be run in Drupal VM. Use outside of Drupal VM will likely result in weird things happening.

## Role Variables

Available variables are listed below:

```yaml
hostname_fqdn: "{{ inventory_hostname }}"
```

The fully qualified domain name. If left blank, the `hostname` command will not be run (this can be useful if running the role within a Docker container).

```yaml
hostname_short: "{{ hostname_fqdn|regex_replace('^([^.]+).*$', '\\1') }}"
```

The shortname defaulting to the part up to the first period of the FQDN, without the rest of the domain.

```yaml
hostname_unsafe_writes: "{{ (ansible_virtualization_type == 'docker')|ternary('yes', 'no')|bool }}"
```

Whether to use unsafe writes or atomic operations when updating system files. Defaults to atomic operations on all systems except for docker where mounted files cannot be updated atomically and can only be done in an unsafe manner.

## Dependencies

None.

## Example Playbook

    - hosts: drupalvm
      roles:
         - drupalvm.hostname

## License

MIT / BSD

## Author Information

This role was created in 2017 by [Oskar Schöldström](http://oxy.fi) and [Jeff Geerling](https://www.jeffgeerling.com/) (author of [Ansible for DevOps](https://www.ansiblefordevops.com/)).
