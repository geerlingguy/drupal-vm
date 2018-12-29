To debug the provisioning step Drupal VM can run the `ansible-playbook` command in verbose mode if you set the `DRUPALVM_DEBUG` environment variable.

```sh
# verbose mode: ansible-playbook -v
DRUPALVM_DEBUG=1 vagrant provision
DRUPALVM_DEBUG=v vagrant provision

# for even more messages: ansible-playbook -vvv
DRUPALVM_DEBUG=vvv vagrant provision

# for debug mode: ansible-playbook -vvvv
DRUPALVM_DEBUG=vvvv vagrant provision
```

In addition to running in verbose mode this also enables deprecation warnings.

For debugging information related to Vagrant see [documentation](https://www.vagrantup.com/docs/other/debugging.html).
