[Pimp my Log](http://pimpmylog.com/) is a PHP-based web GUI for viewing log files on a given server. By default, it is installed on Drupal VM, and you can access it at the URL `http://pimpmylog.drupalvm.dev/` (as long as you have a hosts entry for that URL pointing at Drupal VM's IP address!).

By default, it will find the default Apache 2 `access.log` and `error.log` files, but it will not find other logs, like MySQL or extra Apache virtualhost logs.

When configuring Pimp my Log (on the first visit to the `pimpmylog.drupalvm.dev` URL), you can add extra paths in the UI, or you can add them after the fact by manually editing the configuration file, which by default is stored at `/usr/share/php/pimpmylog/config.user.php`. You can also delete that file and re-configure Pimp my Log via the web UI.

Some log files you may be interested in monitoring:

  - `/var/log/apache2/access.log`
  - `/var/log/apache2/error.log` (this log will show Apache and PHP notices/warnings/errors)
  - `/var/log/apache2/other_vhosts_access.log`
  - `/var/log/mysql.err` (MySQL error log)
  - `/var/log/mysql-slow.log` (MySQL slow query log)
  - `/var/log/syslog` (enable the Drupal syslog module to route watchdog log entries to this file)

For MySQL logs, you might want to read through the PML docs on [MySQL](http://support.pimpmylog.com/kb/softwares/mysql).

It might be necessary to grant read permissions to the other group (e.g. `chmod o+r /var/log/mysql.err`) on some log files in order for Pimp My Log to be able to parse them.
