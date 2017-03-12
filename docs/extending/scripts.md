Drupal VM allows you to run extra shell scripts and ansible task files in the beginning and at the end of the provisioning process, in case you need to do extra setup, further configure the VM, or install extra software outside the purview of Drupal VM.

## Shell scripts

To use an extra script, configure the path to the script (relative to `provisioning/playbook.yml`) in `config.yml`:

```yaml
pre_provision_scripts:
  - "../scripts/pre-provision.sh"
post_provision_scripts:
  - "../scripts/post-provision.sh"
```

The above example results in a `pre-provision.sh` script running before the provisioning starts and a `post-provision.sh` script running after the main Drupal VM setup is complete. Pre and post provision scripts run after the first `vagrant up`, and then any time you run Vagrant provisioning (e.g. `vagrant provision` or `vagrant up --provision`).

_Note: The pre provision scripts run before any other packages are installed. If you want to use commands such as `git`, you need to install the packages yourself._

You can define as many scripts as you would like, and any arguments after the path will be passed to the shell script itself (e.g. `"- "../scripts/setup-paths.sh --option"`).

Place your pre and post provision scripts inside a `scripts` directory in the root of your Drupal VM project directory; this directory is gitignored, so you can continue to update Drupal VM without overwriting your scripts.

## Ansible task files

To use an extra ansible task file, configure the path to the file (relative to `provisioning/playbook.yml`) in `config.yml`:

```yaml
pre_provision_tasks_dir: "../scripts/pre/*"
post_provision_tasks_dir: "../scripts/post-provision.yml"
```

The path will be evaluated as a [glob pattern](https://docs.python.org/2/library/glob.html) so you can point to a single file or a directory matching a set of files.

The files matched will run in alphabetical order, and as with shell scripts, pre-provision task files will run before any other packages are installed.

## Ansible playbooks

Out of the box Drupal VM does not support running additional playbooks or adding your own roles but using [`Vagrantfile.local` you can add any number of additional provisioners to vagrant](vagrantfile.md).

As an example you might have a `local.playbook.yml` with it's own dependencies defined in `local.requirements.yml`. Place both of these next to your `config.yml` and add the following `Vagrantfile.local`.

```rb
config.vm.provision 'ansible' do |ansible|
  ansible.playbook = "#{host_config_dir}/local.playbook.yml"
  ansible.galaxy_role_file = "#{host_config_dir}/local.requirements.yml"
end
```

When you run `vagrant provision` this playbook will run after Drupal VM's own playbook.
