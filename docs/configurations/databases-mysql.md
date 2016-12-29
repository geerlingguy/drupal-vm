By default, this VM is set up so you can manage MySQL databases on your own. The default root MySQL user credentials are `drupal` for username and password, but you can change the password via `config.yml` (changing the `drupal_db_password` variable). I use [Sequel Pro](http://www.sequelpro.com/) (macOS-only) to connect to and manage databases, and Drush to sync databases (sometimes I'll just do a dump and import, but Drush is usually quicker, and is easier to do over and over again when you need it).

## Connect using Adminer

If you have `adminer` listed as one of the `installed_extras` inside `config.yml`, you can use Adminer's web-based interface to interact with databases. With Drupal VM running, visit [http://adminer.drupalvm.dev/](http://adminer.drupalvm.dev/), and log in with `drupal` as the username and the password you set in `config.yml` (`drupal_db_password`). Leave the "Server" field blank. The "Database" field is optional.

More about how to use Adminer: [Adminer website](http://www.adminer.org/).

## Connect using Sequel Pro (or a similar client):

  1. Use the SSH connection type.
  2. Set the following options:
    - MySQL Host: `127.0.0.1`
    - Username: `drupal`
    - Password: `drupal` (or the password configured in `config.yml`)
    - SSH Host: `192.168.88.88` (or  the IP configured in `config.yml`)
    - SSH User: `vagrant`
    - SSH Key: (browse to your `~/.vagrant.d/` folder and choose `insecure_private_key`)

You should be able to connect as the root user and add, manage, and remove databases and users.
