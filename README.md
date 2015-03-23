# Drupal Development VM

**For Drupal 6, 7, 8, etc.**

This project aims to make spinning up a simple local Drupal test/development environment incredibly quick and easy, and to introduce new developers to the wonderful world of Drupal development on local virtual machines (instead of crufty old MAMP/WAMP-based development).

It will install the following on an Ubuntu 14.04 linux VM:

  - Apache 2.4.x
  - PHP 5.5.x (configurable)
  - MySQL 5.5.x
  - Drush latest release (configurable)
  - Drupal 6.x, 7.x, or 8.x.x (configurable)
  - Optional (installed by default):
    - Memcached
    - XHProf, for profiling your code
    - XDebug, for debugging your code
    - PHPMyAdmin, for accessing databases directly
    - MailHog, for catching and debugging email

It should take 5-10 minutes to build or rebuild the VM from scratch on a decent broadband connection.

## Customizing the VM

There are a couple places where you can customize the VM for your needs:

  - `config.yml`: Contains variables like the VM domain name and IP address, PHP and MySQL configuration, etc.
  - `drupal.make.yml`: Contains configuration for the Drupal core version, modules, and patches that will be downloaded on Drupal's initial installation (more about [Drush make files](https://www.drupal.org/node/1432374)).

If you want to switch from Drupal 8 (default) to Drupal 7 or 6 on the initial install, do the following:

  1. Update the Drupal `version` and `core` inside the `drupal.make.yml` file.
  2. Update `drupal_major_version` inside `config.yml`.

## Quick Start Guide

### 1 - Install dependencies (VirtualBox/VMware, Vagrant, Ansible)

  1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) or [VMware](http://www.vmware.com/products/fusion).
  2. Download and install [Vagrant](http://www.vagrantup.com/downloads.html).
  3. [Mac/Linux only] Install [Ansible](http://docs.ansible.com/intro_installation.html).

Note for Windows users: *Ansible will be installed inside the VM, and everything will be configured internally (unlike on Mac/Linux hosts). See [JJG-Ansible-Windows](https://github.com/geerlingguy/JJG-Ansible-Windows) for more information.*

### 2 - Build the Virtual Machine

  1. Download this project and put it wherever you want.
  2. Make copies of both of the `example.*` files, and modify to your liking:
    - Copy `example.drupal.make.yml` to `drupal.make.yml`.
    - Copy `example.config.yml` to `config.yml`.
  3. Create a local directory where Drupal will be installed (so you can work with the files locally or within the VM), and configure the path to that directory in `config.yml`.
  4. Install Ansible Galaxy roles required for this VM: `$ sudo ansible-galaxy install -r requirements.txt`
  5. Open Terminal, cd to this directory (containing the `Vagrantfile` and this README file).
  6. Type in `vagrant up`, and let Vagrant do its magic.

Note: *If there are any errors during the course of running `vagrant up`, and it drops you back to your command prompt, just run `vagrant provision` to continue building the VM from where you left off. If there are still errors after doing this a few times, post an issue to this project's issue queue on GitHub with the error.*

### 3 - Configure your host machine to access the VM.

  1. [Edit your hosts file](http://www.rackspace.com/knowledge_center/article/how-do-i-modify-my-hosts-file), adding the line `192.168.88.88  drupaltest.dev` so you can connect to the VM.
  2. Open your browser and access [http://drupaltest.dev/](http://drupaltest.dev/).

## Syncing folders

You can share folders between your host computer and the VM in a variety of ways; the two most commonly-used methods are using an NFS share, or using Vagrant's rsync method to synchronize a folder from your host into the guest VM. The `example.config.yml` file contains an example `rsync` share that would sync the folder `~/Sites/drupal` on your host into a `/drupal` folder on the VM.

If you want to use NFS for the share instead, you could simply change the share to:

    vagrant_synced_folders:
      - local_path: ~/Sites/drupal
        destination: /drupal
        id: drupal
        type: nfs

You can add as many synced folders as you'd like, and you can configure [any type of share](https://docs.vagrantup.com/v2/synced-folders/index.html) supported by Vagrant; just add another item to the list of `vagrant_synced_folders`.

## Connecting to MySQL

By default, this VM is set up so you can manage mysql databases on your own. The default root MySQL user credentials are `root` for username+password, but you could change the password via `config.yml`. I use the MySQL GUI [Sequel Pro](http://www.sequelpro.com/) (Mac-only) to connect and manage databases, then Drush to sync databases (sometimes I'll just do a dump and import, but Drush is usually quicker, and is easier to do over and over again when you need it).

### Connect using Sequel Pro (or a similar client):

  1. Use the SSH connection type.
  2. Set the following options:
    - MySQL Host: `127.0.0.1`
    - Username: `root`
    - Password: `root` (or whatever password you chose in `config.yml`)
    - SSH Host: `192.168.88.88` (or whatever IP you chose in `config.yml`)
    - SSH User: `vagrant`
    - SSH Key: (browse to your `~/.vagrant.d/` folder and choose `insecure_private_key`)

You should be able to connect as the root user and add, manage, and remove databases and users.

You can also install and use PHPMyAdmin (a simple web-based MySQL GUI) by adding the `geerlingguy.phpmyadmin` role to `provisioning/playbook.yml`, and installing the role with `$ ansible-galaxy install geerlingguy.phpmyadmin`.

## Extra software/utilities

By default, this VM includes the extras listed in the `config.yml` option `installed_extras`:

    installed_extras:
      - mailhog
      - memcached
      - phpmyadmin
      - xdebug
      - xhprof

If you don't want or need one or more of these extras, just delete them or comment them from the list. This is helpful if you want to reduce PHP memory usage or otherwise conserve system resources.

### Using XHProf to Profile Code

The easiest way to use XHProf to profile your PHP code on a Drupal site is to install the Devel module, then in Devel's configuration, check the 'Enable profiling of all page views and drush requests' checkbox. In the settings that appear below, set the following values:

  - **xhprof directory**: `/usr/share/php`
  - **XHProf URL**: `http://local.xhprof.com/` (assuming you have this set in `apache_vhosts` in config.yml)

Also be sure you have `xdebug` in the `installed_extras` list in `config.yml`.

### Using XDebug to Debug Code

XDebug can be a useful tool for debugging PHP applications, but it uses extra memory and CPU for every request, therefore it's disabled by default. To enable XDebug, change the `php_xdebug_default_enable` and `php_xdebug_coverage_enable` to `1` in your `config.yml`, and make sure `xdebug` is in the list of `installed_extras`.

### Catching/Debugging Email with MailHog

By default, the VM is configured to redirect PHP's emails to MailHog (instead of sending them to the outside world). You can access the MailHog UI at `http://drupaltest.dev:8025/` (where `drupaltest.dev` is the domain you've configured for the VM).

You can override the default behavior of redirecting email to MailHog by editing or removing the `php_sendmail_path` inside `config.yml`, and you can choose to not install MailHog at all by removing it from `installed_extras` in `config.yml`.

## Drupal 6 Notes

If you'd like to use the included configuration and Drush make file to install a Drupal 6 site using an older version of Drush (< 7.x), you may need to make some changes, namely:

  - Drush < 7.x does not support .yml makefiles; if using Drush 5.x or 6.x, you will need to create the make file in the INI-style format.
  - In your customized `config.yml` file, you will need to use the `default` installation profile instead of `standard` (for the `drupal_install_profile` variable).

## Other Notes

  - To shut down the virtual machine, enter `vagrant halt` in the Terminal in the same folder that has the `Vagrantfile`. To destroy it completely (if you want to save a little disk space, or want to rebuild it from scratch with `vagrant up` again), type in `vagrant destroy`.
  - When you rebuild the VM (e.g. `vagrant destroy` and then another `vagrant up`), make sure you clear out the contents of the `drupal` folder on your host machine, or Drupal will return some errors when the VM is rebuilt (it won't reinstall Drupal cleanly).
  - You can change the installed version of Drupal or drush, or any other configuration options, by editing the variables within `vars/main.yml`.
  - Find out more about local development with Vagrant + VirtualBox + Ansible in this presentation: [Local Development Environments - Vagrant, VirtualBox and Ansible](http://www.slideshare.net/geerlingguy/local-development-on-virtual-machines-vagrant-virtualbox-and-ansible).
  - Learn about how Ansible can accelerate your ability to innovate and manage your infrastructure by reading [Ansible for DevOps](https://leanpub.com/ansible-for-devops).

## About the Author

[Jeff Geerling](http://jeffgeerling.com/), owner of [Midwestern Mac, LLC](http://www.midwesternmac.com/), created this project in 2014 so he could accelerate his Drupal core and contrib development workflow. This project, and others like it, are also featured as examples in Jeff's book, [Ansible for DevOps](https://leanpub.com/ansible-for-devops).
