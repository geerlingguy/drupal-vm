Drupal VM allows you to run extra shell scripts at the end of the provisioning process, in case you need to do extra setup, further configure the VM, or install extra software outside the purview of Drupal VM.

To use an extra script, configure the path to the script (relative to `provisioning/playbook.yml`) in `config.yml`:

```yaml
post_provision_scripts:
  - "../scripts/post-provision.sh"
```

The above example results in a `post-provision.sh` script running after the main Drupal VM setup is complete. Note that post provision scripts run _every_ time you the VM is provisioned provision the environment (e.g. when you run `vagrant up` or `vagrant provision`).

You can define as many scripts as you would like, and any arguments after the path will be passed to the shell script itself (e.g. `"- "../scripts/setup-paths.sh --option"`).

Place your post-provision scripts inside a `scripts` directory in the root of your Drupal VM project directory; this directory is gitignored, so you can continue to update Drupal VM without overwriting your scripts.
