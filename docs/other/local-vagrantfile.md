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

## Example: Using the `vagrant-aws` provider

Add the following variables to your `config.yml`.

```yaml
aws_keypair_name: 'keypair'
aws_ami: 'ami-7747d01e'
aws_tags_name: 'Drupal VM'
aws_ssh_username: 'ubuntu'
aws_ssh_private_key: '~/.ssh/aws.pem'
```

Create a `Vagrantfile.local` in the root directory of your project.

```ruby
config.vm.provider :aws do |aws, override|
  override.nfs.functional = false

  aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
  aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  aws.keypair_name = vconfig['aws_keypair_name']
  aws.tags['Name'] = vconfig['aws_tags_name']
  aws.ami = vconfig['aws_ami']

  override.ssh.username = vconfig['aws_ssh_username']
  override.ssh.private_key_path = vconfig['aws_ssh_private_key']
end
```

Add the `AWS_ACCESS_KEY_ID` and the `AWS_SECRET_ACCESS_KEY` environment variables to your shell.

Then run `vagrant up --provider=aws` to provision the instance.

_For additional configuring options read the [Vagrant AWS Provider's README](https://github.com/mitchellh/vagrant-aws#readme)_
