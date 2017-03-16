## Run a specific set of tagged tasks

You can filter which part of the provisioning process to run by specifying a set of tags using the `DRUPALVM_ANSIBLE_TAGS` environment variable.

```sh
# E.g. xdebug, drupal, webserver, database, cron...
DRUPALVM_ANSIBLE_TAGS=xdebug vagrant provision

# Or combine them (e.g. if adding new databases and virtualhosts).
DRUPALVM_ANSIBLE_TAGS=webserver,database vagrant provision
```

## Passing arguments to ansible during a provision

You can specify an additional argument to the `ansible-playbook` command by using the `DRUPALVM_ANSIBLE_ARGS` environment variable. This can be useful when debugging a task failure.

> Note the following caveats:
>
>   - Passing more than one argument may require special formatting. Read the [Ansible provisioner's `raw_arguments` docs](https://www.vagrantup.com/docs/provisioning/ansible_common.html#raw_arguments) for more info.
>   - You should not quote a flag's value as you would normally do in the shell.

Display verbose ansible output:

```sh
DRUPALVM_ANSIBLE_ARGS='--verbose' vagrant provision
```

Begin the provisioning at a particular task:

```sh
DRUPALVM_ANSIBLE_ARGS='--start-at-task=*post-provision shell*' vagrant provision
```

Override a config variable:

```sh
DRUPALVM_ANSIBLE_ARGS='--extra-vars=drupal_db_backend=pgsql' vagrant provision
```
