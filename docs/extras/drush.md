If you have Drush and Ansible installed on your host workstation, and would like to interact with a Drupal site running inside Drupal VM, there are drush aliases automatically created by Drupal VM for each of the virtual hosts you have configured.

With the example configuration, you can manage the example Drupal site using the Drush alias `@drupalvm.dev`. For example, to check if Drush can connect to the site in Drupal VM, run:

```
$ drush @drupalvm.dev status
 Drupal version         :  8.0.0-dev
 Site URI               :  drupalvm.dev
 Database driver        :  mysql
 Database hostname      :  localhost
 Database port          :
 Database username      :  drupal
 Database name          :  drupal
 Database               :  Connected
 Drupal bootstrap       :  Successful
 Drupal user            :  Anonymous
 Default theme          :  bartik
 Administration theme   :  seven
 PHP executable         :  /usr/bin/php
 PHP configuration      :  /etc/php5/cli/php.ini
 PHP OS                 :  Linux
 Drush script           :  /usr/local/share/drush/drush.php
 Drush version          :  7.0-dev
 Drush temp directory   :  /tmp
 Drush configuration    :
 Drush alias files      :
 Drupal root            :  /var/www/drupalvm/drupal
 Site path              :  sites/default
 File directory path    :  sites/default/files
 Temporary file         :  /tmp
 directory path
 Active config path     :  [...]
 Staging config path    :  [...]
```

Drupal VM automatically generates a drush alias file in `~/.drush/drupalvm.aliases.drushrc.php` with an alias for every site you have defined in the `apache_vhosts` variable.

You can disable Drupal VM's automatic Drush alias file management if you want to manage drush aliases on your own. Just set the `configure_drush_aliases` variable in `config.yml` to `false`.

## Using sql-sync

For sql-sync to work between two remotes make sure you are running Drush 8.0.3 or later on your host and your guest machine, as well as 7.1.0 or later on the remote.

If you're locked to an older version of Drush, it is likely that Drush will try to run the command from the `@destination` instead of from your host computer, which means you need to move your `@remote` alias to Drupal VM as well. You can place the file in any of the [directories Drush searches](https://github.com/drush-ops/drush/blob/5a1328d6e9cb919a286e70360df159d1b4b15d3e/examples/example.aliases.drushrc.php#L43:L51), for example `/home/vagrant/.drush/<remote-alias>.aliases.drushrc.php`.

If you're still having issues, you can avoid `sql-sync` entirely and pipe the mysqldump output yourself with:

```
drush @remote sql-dump | drush @drupalvm.drupalvm.dev sql-cli
```
