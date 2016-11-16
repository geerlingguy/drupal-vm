Drupal VM has _experimental_ support for deploying Drupal VM to a production environment. The security of your servers is _your_ responsibility.

For a configuration example and instructions on how to build a Drupal environment with Drupal VM on DigitalOcean see the [`examples/prod` directory and README](https://github.com/geerlingguy/drupal-vm/tree/master/examples/prod).

## Production specific overrides.

Drupal VM supports loading configuration files depending on the environment variable `DRUPALVM_ENV` and using this feature you can have different configurations between development and production environments.

```sh
# Loads vagrant.config.yml if available (default).
vagrant provision

# Loads prod.config.yml if available.
DRUPALVM_ENV=prod vagrant provision --provisioner=aws
```

If you're issuing a provision directly through `ansible-playbook` as you would do for most production environments you can either set the `DRUPALVM_ENV` variable on your host, or on the remote production machine.

```sh
# By default it doesn't try to load any other config file.
ansible-playbook -i examples/prod/inventory provisioning/playbook.yml --sudo --ask-sudo-pass

# Loads prod.config.yml if available.
DRUPALVM_ENV=prod ansible-playbook -i examples/prod/inventory provisioning/playbook.yml --sudo --ask-sudo-pass
```

If you add `DRUPALVM_ENV=prod` to the `/etc/environment` file on your production environment:

```sh
# Loads prod.config.yml if available.
ansible-playbook -i examples/prod/inventory provisioning/playbook.yml --sudo --ask-sudo-pass
```

_Note: Having the variable set locally takes precedence over having it on the remote machine._
