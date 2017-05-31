Out of the box Drupal VM supports having VirtualBox, Parallels as well as VMware as a provider. Besides these there are multitude of others available (for example `vagrant-aws`, `vagrant-digitalocean`).  If you want to use an unsupported provider, or otherwise modify the vagrant configuration in a way that is not exposed by Drupal VM, you can create a `Vagrantfile.local` next to your `config.yml`.

The file will be sourced at the end of the `Vagrant.configure` block so you will have access to Vagrant's `config.vm` object as well as the contents of the `config.yml` file within the `vconfig` hash.

To add a configuration just create a `Vagrantfile.local` in the root like so:

```ruby
config.vm.provider :virtualbox do |v|
  # Enable GUI mode instead of running a headless machine.
  v.gui = true

  # Cap the host CPU execution at 50% usage.
  v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
end
```

### Automatically install Vagrant plugins

Drupal VM can be configured to ensure Vagrant plugins are installed by adding them to the `vagrant_plugins` list in your `config.yml` file.

```yaml
vagrant_plugins:
 - name: vagrant-vbguest
 - name: vagrant-hostsupdater
 - name: vagrant-aws
```

### Example: Using the `vagrant-aws` provider

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

_For additional configuration options read the [Vagrant AWS Provider's README](https://github.com/mitchellh/vagrant-aws#readme)._

### Example: Using Drupal VM behind a corporate proxy with `vagrant-proxyconf`

Add the following variables to your `config.yml`.

```yaml
proxy_http: 'http://192.168.0.2:3128/'
proxy_https: 'http://192.168.0.2:3128/'
proxy_ftp: 'http://192.168.0.2:3128/'
proxy_none: 'localhost,127.0.0.1,{{ drupal_domain }}'
```

Create a `Vagrantfile.local` in the root directory of your project.

```ruby
if Vagrant.has_plugin?('vagrant-proxyconf')
  config.proxy.http = vconfig['proxy_http']
  config.proxy.https = vconfig['proxy_https']
  config.git_proxy.http = vconfig['proxy_http']
  config.proxy.no_proxy = vconfig['proxy_none']
  config.proxy.ftp = vconfig['proxy_ftp']
end
```

_For additional configuration options read [Vagrant Proxyconf's README](https://github.com/tmatilai/vagrant-proxyconf#readme)._
