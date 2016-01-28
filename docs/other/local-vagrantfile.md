Out of the box Drupal VM supports having VirtualBox, Parallels as well as VMware as a provider. Besides these there are multitude of others available (for example `vagrant-aws`, `vagrant-digitalocean`).

If you want to use an unsupported provider, or otherwise modify the vagrant configuration in a way that is not exposed by Drupal VM, you can create a `Vagrantfile.local` in the root directory of this project.

The file will be sourced at the end of the `Vagrant.configure` block so you will have access to Vagrant's `config.vm` object as well as the contents of the `config.yml` file within the `vconfig` hash.

To add a configuration just create a `Vagrantfile.local` in the root like so:

```ruby
config.vm.provider :virtualbox do |v|
  # Enable GUI mode instead of running a headless machine.
  v.gui = true

  # Reduce disk usage of multiple boxes by sharing a master VM.
  v.linked_clone = true

  # Cap the host CPU execution at 50% usage.
  v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
end
```
