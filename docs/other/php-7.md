Many users have requested the ability to easily install PHP 7.x in addition to the already easy-to-configure options of 5.3, 5.4, 5.5, and 5.6. This page will guide you through how to get PHP 7 running on Drupal VM by modifying a few configuration options and running a couple simple commands inside the VM.

Note that, at this time (summer 2015), PHP 7 is still in pre-beta releases, and all support is experimental and prone to breaking things. Please don't try running PHP 7 on production machines yet!

## Ubuntu 14.04

Currently the most reliable way to get PHP 7 (any version) running on Ubuntu is to build from source. This is supported by Drupal VM and is not too difficult, but it requires a few manual steps to make sure Apache and PHP play nice together, so this process is not currently documented here.

Otherwise, Ondřej Surý also has a PPA for PHP 7.0 that is included with Drupal VM, and you can make the following additions/changes to your `config.yml` to use it:

```yaml
php_version: "7.0"
php_packages:
  - libapache2-mod-php7.0
  - php7.0-mcrypt
  - php7.0-common
  - php7.0-cli
  - php7.0-curl
  - php7.0-dev
  - php7.0-fpm
  - php7.0-gd
  - libpcre3-dev
php_mysql_package: php7.0-mysqlnd
```

However, there's currently a bug with the beta1 version of the package, which causes installation to fail (see: https://github.com/oerdnj/deb.sury.org/issues/87). This section will be updated with more information once this packaging bug is fixed or a workaround is found.

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