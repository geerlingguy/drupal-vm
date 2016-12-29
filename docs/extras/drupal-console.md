[Drupal Console](https://drupalconsole.com/) is a modern CLI for interacting with Drupal and scaffolding a site. It works only with Drupal 8+, and is built on top of the Symfony Console component.

Drupal VM will automatically install Drupal Console if you install Drupal 8 or later in your VM (this is based on the value of the `drupal_major_version` variable inside `config.yml`.

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

## Remote command execution

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
