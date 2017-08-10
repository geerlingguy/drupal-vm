[Drupal Console](https://drupalconsole.com/) is a modern CLI for interacting with Drupal and scaffolding a site. It works only with Drupal 8+, and is built on top of the Symfony Console component.

To have Drupal Console installed globally inside Drupal VM, make sure `drupalconsole` is in the list of `installed_extras` in your `config.yml` file. If you're adding it to an existing Drupal VM, run `vagrant provision` so it gets installed. You also (or instead) might want to add Drupal Console as a dependency of your Drupal project—if you do this, you may not need to add `drupalconsole` to Drupal VM globally.

To use Drupal Console with a Drupal 8 site (in this case, using the default configuration that ships with Drupal VM):

  1. Log into the VM with `vagrant ssh`.
  2. Change directory to the Drupal site's document root: `cd /var/www/drupalvm/drupal/web`.
  3. Use Drupal console (e.g. `drupal cache:rebuild all`).

You should see an output like:

```
vagrant@drupalvm:/var/www/drupalvm/drupal/web$ drupal cache:rebuild all

[+] Rebuilding cache(s), wait a moment please.
[+] Done clearing cache(s).

 The command was executed successfully!
```

## Remote command execution using `--target`

To run commands on your host computer but execute them on the VM, add a new sites file `~/.console/sites/drupalvm.yml` on your host computer:

```yaml
dev:
  root: /var/www/drupalvm/drupal
  host: 192.168.88.88
  user: vagrant
  password: vagrant
```

Execute from host machine using the `--target` option.

    drupal --target=drupalvm.dev site:status

For more details, see [Drupal Console's documentation](https://hechoendrupal.gitbooks.io/drupal-console/content/en/using/how-to-use-drupal-console-in-a-remote-installation.html)

For a list of available role variables, see the [`geerlingguy.drupal-console` Ansible role's README](https://github.com/geerlingguy/ansible-role-drupal-console#readme).

## Remote command execution using `vagrant-exec`

You can use [`vagrant-exec`](https://github.com/p0deje/vagrant-exec) to execute commands remotely through Vagrant, and if you can't get Console to work with `--target`, you might want to try doing this (it's more convenient than logging into the VM just to run a Drupal VM command!).

First, install the plugin:

    vagrant plugin install vagrant-exec

Add the following to a `Vagrantfile.local` in your project (set `directory` to your drupal docroot):

```ruby
if Vagrant.has_plugin?('vagrant-exec')
  config.exec.commands '*', directory: '/var/www/drupal'
end
```

Now you can execute any Drupal Console command—even interactive ones!—from the host:

    vagrant exec bin/drupal generate:module
