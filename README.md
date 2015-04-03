# Drupal Development VM

http://www.drupalvm.com/

[![Build Status](https://travis-ci.org/geerlingguy/drupal-vm.svg?branch=master)](https://travis-ci.org/geerlingguy/drupal-vm)

**For Drupal 6, 7, 8, etc.**

This project aims to make spinning up a simple local Drupal test/development environment incredibly quick and easy, and to introduce new developers to the wonderful world of Drupal development on local virtual machines (instead of crufty old MAMP/WAMP-based development).

It will install the following on an Ubuntu 14.04 linux VM:

  - Apache 2.4.x
  - PHP 5.5.x (configurable)
  - MySQL 5.5.x
  - Drush latest release (configurable)
  - Drupal 6.x, 7.x, or 8.x.x (configurable)
  - Optional (installed by default):
    - Apache Solr 4.10.x (configurable)
    - Memcached
    - XHProf, for profiling your code
    - XDebug, for debugging your code
    - PHPMyAdmin, for accessing databases directly
    - MailHog, for catching and debugging email

It should take 5-10 minutes to build or rebuild the VM from scratch on a decent broadband connection.

Please read through the rest of this README and the [Drupal VM Wiki](https://github.com/geerlingguy/drupal-vm/wiki) for help getting Drupal VM configured and integrated with your development workflow.

## Customizing the VM

There are a couple places where you can customize the VM for your needs:

  - `config.yml`: Contains variables like the VM domain name and IP address, PHP and MySQL configuration, etc.
  - `drupal.make.yml`: Contains configuration for the Drupal core version, modules, and patches that will be downloaded on Drupal's initial installation (more about [Drush make files](https://www.drupal.org/node/1432374)).

If you want to switch from Drupal 8 (default) to Drupal 7 or 6 on the initial install, do the following:

  1. Update the Drupal `version` and `core` inside the `drupal.make.yml` file.
  2. Update `drupal_major_version` inside `config.yml`.

## Quick Start Guide

This Quick Start Guide will help you quickly build a Drupal 8 site on the Drupal VM using the included example Drush make file. You can also use the Drupal VM with a [Local Drupal codebase](https://github.com/geerlingguy/drupal-vm/wiki/Local-Drupal-codebase) or even a [Drupal multisite installation](https://github.com/geerlingguy/drupal-vm/wiki/Drupal-multisite).

### 1 - Install dependencies (VirtualBox, Vagrant, Ansible)

  1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (Drupal VM also works with VMware, if you have the [Vagrant VMware integration plugin](http://www.vagrantup.com/vmware)).
  2. Download and install [Vagrant](http://www.vagrantup.com/downloads.html).
  3. [Mac/Linux only] Install [Ansible](http://docs.ansible.com/intro_installation.html).

Note for Windows users: *Ansible will be installed inside the VM, and everything will be configured internally (unlike on Mac/Linux hosts). See [JJG-Ansible-Windows](https://github.com/geerlingguy/JJG-Ansible-Windows) for more information.*

Note for Linux users: *If NFS is not already installed on your host, you will need to install it to use the default NFS synced folder configuration. See guides for [Debian/Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-14-04), [Arch](https://wiki.archlinux.org/index.php/NFS#Installation), and [RHEL/CentOS](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-centos-6).*

### 2 - Build the Virtual Machine

  1. Download this project and put it wherever you want.
  2. Make copies of both of the `example.*` files, and modify to your liking:
    - Copy `example.drupal.make.yml` to `drupal.make.yml`.
    - Copy `example.config.yml` to `config.yml`.
  3. Create a local directory where Drupal will be installed and configure the path to that directory in `config.yml` (`local_path`, inside `vagrant_synced_folders`).
  4. Open Terminal, cd to this directory (containing the `Vagrantfile` and this README file).
  5. [Mac/Linux only] Install Ansible Galaxy roles required for this VM: `$ sudo ansible-galaxy install -r requirements.txt`
  6. Type in `vagrant up`, and let Vagrant do its magic.

Note: *If there are any errors during the course of running `vagrant up`, and it drops you back to your command prompt, just run `vagrant provision` to continue building the VM from where you left off. If there are still errors after doing this a few times, post an issue to this project's issue queue on GitHub with the error.*

### 3 - Configure your host machine to access the VM.

  1. [Edit your hosts file](http://www.rackspace.com/knowledge_center/article/how-do-i-modify-my-hosts-file), adding the line `192.168.88.88  drupaltest.dev` so you can connect to the VM. (Alternatively, you can install a Vagrant plugin to automatically add and remove the entry from your hosts file; run `vagrant plugin install vagrant-hostsupdater`).
  2. Open your browser and access [http://drupaltest.dev/](http://drupaltest.dev/). The default login for the admin account is `admin` for both the username and password.

## Extra software/utilities

By default, this VM includes the extras listed in the `config.yml` option `installed_extras`:

    installed_extras:
      - mailhog
      - memcached
      - phpmyadmin
      - solr
      - xdebug
      - xhprof

If you don't want or need one or more of these extras, just delete them or comment them from the list. This is helpful if you want to reduce PHP memory usage or otherwise conserve system resources.

## Using Drupal VM

Drupal VM is built to integrate with every developer's workflow. Many guides for using Drupal VM for common development tasks are available on the [Drupal VM Wiki](https://github.com/geerlingguy/drupal-vm/wiki):

  - [Syncing Folders](https://github.com/geerlingguy/drupal-vm/wiki/Syncing-Folders)
  - [Connect to the MySQL Database](https://github.com/geerlingguy/drupal-vm/wiki/Connect-to-the-MySQL-Database)
  - [Use Apache Solr for Search](https://github.com/geerlingguy/drupal-vm/wiki/Use-Apache-Solr-for-Search)
  - [Use Drush with Drupal VM](https://github.com/geerlingguy/drupal-vm/wiki/Use-Drush-with-Drupal-VM)
  - [Profile Code with XHProf](https://github.com/geerlingguy/drupal-vm/wiki/Profile-Code-with-XHProf)
  - [Debug Code with XDebug](https://github.com/geerlingguy/drupal-vm/wiki/Debug-Code-with-XDebug)
  - [Catch Emails with MailHog](https://github.com/geerlingguy/drupal-vm/wiki/Catch-Emails-with-MailHog)
  - [Drupal 6 Notes](https://github.com/geerlingguy/drupal-vm/wiki/Drupal-6-Notes)

## Other Notes

  - To shut down the virtual machine, enter `vagrant halt` in the Terminal in the same folder that has the `Vagrantfile`. To destroy it completely (if you want to save a little disk space, or want to rebuild it from scratch with `vagrant up` again), type in `vagrant destroy`.
  - When you rebuild the VM (e.g. `vagrant destroy` and then another `vagrant up`), make sure you clear out the contents of the `drupal` folder on your host machine, or Drupal will return some errors when the VM is rebuilt (it won't reinstall Drupal cleanly).
  - You can change the installed version of Drupal or drush, or any other configuration options, by editing the variables within `vars/main.yml`.
  - Find out more about local development with Vagrant + VirtualBox + Ansible in this presentation: [Local Development Environments - Vagrant, VirtualBox and Ansible](http://www.slideshare.net/geerlingguy/local-development-on-virtual-machines-vagrant-virtualbox-and-ansible).
  - Learn about how Ansible can accelerate your ability to innovate and manage your infrastructure by reading [Ansible for DevOps](https://leanpub.com/ansible-for-devops).

## About the Author

[Jeff Geerling](http://jeffgeerling.com/), owner of [Midwestern Mac, LLC](http://www.midwesternmac.com/), created this project in 2014 so he could accelerate his Drupal core and contrib development workflow. This project, and others like it, are also featured as examples in Jeff's book, [Ansible for DevOps](https://leanpub.com/ansible-for-devops).
