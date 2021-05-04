# Drupal VM Vagrant NFS Fix Role

This role exists to fix [issue #2154](https://github.com/geerlingguy/drupal-vm/issues/2154).

## Requirements

This role is meant to be run in Drupal VM.

## Role Variables

Available variables are listed below:

```yaml
vagrant_nfs_fix_keepalive_file: "/vagrant/.vagrant-nfs-fix-keepalive.tmp"
```

Path to the keepalive file that we'll be `touch`ed every 30 seconds to keep NFS from timing out.

## Dependencies

None.

## License

MIT / BSD

## Author Information

This role was created in 2021 by [Oskar Schöldström](http://oxy.fi) and [Jeff Geerling](https://www.jeffgeerling.com/) (author of [Ansible for DevOps](https://www.ansiblefordevops.com/)).
