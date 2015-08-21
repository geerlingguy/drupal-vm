Many users have requested the ability to easily install PHP 7.x in addition to the already easy-to-configure options of 5.3, 5.4, 5.5, and 5.6. This page will guide you through how to get PHP 7 running on Drupal VM in a few different ways, depending on what type of installation you need.

_At this time (summer 2015), PHP 7 is still in the release candidate stage, and all support is experimental and prone to breaking. Please don't try running PHP 7 on production environments yet!_

## Ubuntu 14.04

Ondřej Surý's PPA for PHP 7.0 is included with Drupal VM, and you can make the following changes/additions to `config.yml` to use it:

```yaml
php_version: "7.0"
php_packages:
  - libapache2-mod-php7.0
  - php7.0-common
  - php7.0-cli
  - php7.0-dev
  - php7.0-fpm
  - libpcre3-dev
  - php-gd
  - php-curl
  - php-imap
  - php-json
  - php-opcache
php_mysql_package: php-mysql
```

Note that there can still be a few inconsistencies with this configuration, especially as PHP 7.0.0 is still in 'release candidate status'. You can also build from source using the same/included `geerlingguy.php` Ansible role, but that process is a bit more involved and for power users comfortable with the process.

## RedHat/CentOS 7

After configuring Drupal VM to [use a different base OS](https://github.com/geerlingguy/drupal-vm/wiki/Using-Different-Base-OSes) (in this case, CentOS 7), you need to do the following to get PHP 7 running inside the VM:

  1. Make the changes to `config.yml` defined in the code block at the end of these instructions ('Changes to make PHP 7 work...').

  2. At this time, automatic install of `xhprof` and `xdebug` are unsupported. Make sure these options are commented or removed from the `installed_extras` setting in `config.yml`.

  3. Run the normal `vagrant up` as you would with PHP 5.x, but when provisioning fails (usually on the Composer step), log into the VM with `vagrant ssh`, and run the following two commands:
    ```
    sudo ln -s /usr/bin/php70 /usr/bin/php
    sudo systemctl restart httpd.service
    ```

  4. Log back out (type `exit` to exit the session in the VM) and run `vagrant provision`. This should pick back up where the provisioning left off earlier, and complete installation.

Note: Make sure you're running the latest version of all Ansible role dependencies by running `ansible-galaxy install -r provisioning/requirements.txt --force` inside the root Drupal VM project folder.

    # Changes to make PHP 7 work in CentOS via Remi's repo.
    php_executable: php70
    php_packages:
      - php70
      - php70-php
      - php70-fakepear
      - php70-php-devel
      - php70-php-gd
      - php70-php-imap
      - php70-php-ldap
      - php70-php-mbstring
      - php70-php-pdo
      - php70-php-process
      - php70-php-xml
      - php70-php-xmlrpc
    php_mysql_package: php70-php-mysqlnd

## Zend nightly PHP 7 builds

Zend has a repository with [nightly PHP 7 builds](http://php7.zend.com/repo.php) for either RHEL/CentOS 7 or Debian 8/Ubuntu 14.04, but the repository requires some manual configuration and setup and is not going to be officially supported as a PHP 7 installation method within Drupal VM.
