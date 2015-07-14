By default, this VM is set up so you can manage MySQL databases on your own. The default root MySQL user credentials are `root` for username and password, but you can change the password via `config.yml` (changing the `mysql_root_password` variable). I use the [Sequel Pro](http://www.sequelpro.com/) (Mac-only) to connect and manage databases, and Drush to sync databases (sometimes I'll just do a dump and import, but Drush is usually quicker, and is easier to do over and over again when you need it).

## Connect using phpMyAdmin

If you have `phpmyadmin` listed as one of the `installed_extras` inside `config.yml`, you can use phpMyAdmin's web-based interface to interact with databases. With Drupal VM running, visit `http://drupaltest.dev/phpmyadmin/`, and log in with `root` as the username and the password you set in `config.yml` (`mysql_root_password`).

More about how to use phpMyAdmin: [phpMyAdmin documentation](http://docs.phpmyadmin.net/).

_Note_: If you get the error `#1146 - Table 'phpmyadmin.pma_table_uiprefs' doesn't exist` when browsing tables in phpMyAdmin, please log into the VM using `vagrant ssh`, then run the command `sudo dpkg-reconfigure phpmyadmin`, and follow the onscreen prompts. This error is caused by [a bug in phpMyAdmin's Ubuntu package installation](https://github.com/geerlingguy/ansible-role-phpmyadmin/issues/1#issuecomment-92461536).

## Connect using Sequel Pro (or a similar client):

  1. Use the SSH connection type.
  2. Set the following options:
    - MySQL Host: `127.0.0.1`
    - Username: `root`
    - Password: `root` (or the password configured in `config.yml`)
    - SSH Host: `192.168.88.88` (or  the IP configured in `config.yml`)
    - SSH User: `vagrant`
    - SSH Key: (browse to your `~/.vagrant.d/` folder and choose `insecure_private_key`)

You should be able to connect as the root user and add, manage, and remove databases and users.