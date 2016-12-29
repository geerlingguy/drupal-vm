## Passing arguments to ansible during a provision

You can specify an additional argument to the `ansible-playbook` command by using the `DRUPALVM_ANSIBLE_ARGS` environment variable. This can be useful when debugging a task failure.

_Currently this feature has two quirks. It's only possible to pass on a single argument. You should not quote a flag's value as you would normally do in the shell._

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
DRUPALVM_ANSIBLE_ARGS='--extra-vars=drupalvm_database=pgsql' vagrant provision
```
