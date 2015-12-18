# Example Scripts for Drupal VM

## Post-Provision Scripts

Drupal VM allows you to run extra shell scripts at the end of the provisioning process, in case you need to do extra custom setup, configure your environment, or install extra software outside the purview of Drupal VM.

To use an extra script, configure the path to the script (relative to `provisioning/playbook.yml`) in `config.yml`:

```yaml
post_provision_scripts:
  - "../examples/post-provision.sh"
```

The above example results in the example `post-provision.sh` script running after the main Drupal VM setup is complete. Note that this script would run _every_ time you provision the environment (e.g. once when you run `vagrant up`, then again every time you run `vagrant provision` again).

You can define as many scripts as you would like, and any arguments after the path will be passed to the shell script itself (e.g. `"../examples/post-provision.sh --option"`).

Generally, you should place your post-provision scripts inside a `scripts` directory in the root of your Drupal VM project directory; this directory is gitignored, so you can continue to update Drupal VM without accidentally overwriting your scripts.
