[Drupal Console](http://drupalconsole.com/) is a modern CLI for interacting with Drupal and scaffolding a site. It works only with Drupal 8+, and is built on top of the Symfony Console component.

Drupal VM will automatically install Drupal Console if you install Drupal 8 or later in your VM (this is based on the value of the `drupal_major_version` variable inside `config.yml`.

To use Drupal Console with a Drupal 8 site (in this case, using the default configuration that ships with Drupal VM):

  1. Log into the VM with `vagrant ssh`.
  2. Change directory to the Drupal site's document root: `cd /var/www/drupal`.
  3. Use Drupal console (e.g. `drupal cache:rebuild --cache=all`).

You should see an output like:

```
vagrant@drupaltest:/var/www/drupal$ drupal cache:rebuild --cache=all

[+] Rebuilding cache(s), wait a moment please.
[+] Done clearing cache(s).

 The command was executed successfully!
```