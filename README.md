# Drupal Development VM

**For Drupal 6, 7, 8, etc.**

This project aims to make spinning up a simple local Drupal test/development environment incredibly quick and easy, and to introduce new developers to the wonderful world of Drupal development on local virtual machines (instead of crufty old MAMP/WAMP-based development).

It will install the following on an Ubuntu 14.04 (Trusty Tahr) GNU/Linux VM:

  - Apache 2.4.x
  - PHP 5.5.x
  - MySQL 5.5.x
  - Drush latest release (configurable)
  - Drupal 6.x, 7.x, or 8.x.x (configurable)
  - XHProf, for profiling your code
  - XDebug, for debugging your code

It should take 5-10 minutes to build or rebuild the VM from scratch on a decent broadband connection.

## Customizing the VM

There are a couple places where you can customize the VM for your needs:

  - `provisioning/vars/main.yml`: Contains variables like the VM domain name (where you can access the Drupal site), MySQL configuration, etc.
  - `drupal.make`: Contains configuration for the Drupal core version, modules, and patches that will be downloaded on Drupal's initial installation (more about [Drush make files](https://www.drupal.org/node/1432374)).

If you want to switch from Drupal 8 (default) to Drupal 7 or 6 on the initial install, do the following:

  1. Update `projects[drupal][version]` and `core` inside the `drupal.make` file.
  2. Update `drupal_major_version` inside `provisioning/vars/main.yml`.

## Quick Start Guide

### 1 - Install dependencies (VirtualBox, Vagrant, Ansible)

  1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads).
  2. Download and install [Vagrant](http://www.vagrantup.com/downloads.html).
  3. [Mac/Linux only] Install [Ansible](http://docs.ansible.com/intro_installation.html).

Note for Windows users: *This guide assumes you're on a Mac or Linux host. Windows support may be added when I get a little more time; the main difference is Ansible needs to be bootstrapped from within the VM after it's created. See [JJG-Ansible-Windows](https://github.com/geerlingguy/JJG-Ansible-Windows) for more information.*

### 2 - Build the Virtual Machine

  1. Download this project and put it wherever you want.
  2. Install Ansible Galaxy roles required for this VM: `$ sudo ansible-galaxy install -r requirements.txt`
  3. Open Terminal, cd to this directory (containing the `Vagrantfile` and this README file).
  4. Type in `vagrant up`, and let Vagrant do its magic.

Note: *If there are any errors during the course of running `vagrant up`, and it drops you back to your command prompt, just run `vagrant provision` to continue building the VM from where you left off. If there are still errors after doing this a few times, post an issue to this project's issue queue on GitHub with the error.*

### 3 - Configure your host machine to access the VM.

  1. [Edit your hosts file](http://www.rackspace.com/knowledge_center/article/how-do-i-modify-my-hosts-file), adding the line `192.168.88.88  drupaltest.dev` so you can connect to the VM.
  2. Open your browser and access [http://drupaltest.dev/](http://drupaltest.dev/).

## Connecting to MySQL

By default, this VM is set up so you can manage mysql databases on your own. The default root MySQL user credentials are `root` for username+password, but you could change the password via `config.yml`. I use the MySQL GUI [Sequel Pro](http://www.sequelpro.com/) (Mac-only) to connect and manage databases, then Drush to sync databases (sometimes I'll just do a dump and import, but Drush is usually quicker, and is easier to do over and over again when you need it).

### Connect using Sequel Pro (or a similar client):

  1. Use the SSH connection type.
  2. Set the following options:
    - MySQL Host: `127.0.0.1`
    - Username: `root`
    - Password: `root` (or whatever password you chose in `config.yml`)
    - SSH Host: `192.168.4.40` (or whatever IP you chose in `config.yml`)
    - SSH User: `vagrant`
    - SSH Key: (browse to your `~/.vagrant.d/` folder and choose `insecure_private_key`)

You should be able to connect as the root user and add, manage, and remove databases and users.

You can also install and use PHPMyAdmin (a simple web-based MySQL GUI) by adding the `geerlingguy.phpmyadmin` role to `provisioning/playbook.yml`, and installing the role with `$ ansible-galaxy install geerlingguy.phpmyadmin`.

## Using XHProf to Profile Code

The easiest way to use XHProf to profile your PHP code on a Drupal site is to install the Devel module, then in Devel's configuration, check the 'Enable profiling of all page views and drush requests' checkbox. In the settings that appear below, set the following values:

  - **xhprof directory**: `/usr/share/php`
  - **XHProf URL**: `http://local.xhprof.com/` (assuming you have this set in `apache_vhosts` in config.yml)

## Notes

  - To shut down the virtual machine, enter `vagrant halt` in the Terminal in the same folder that has the `Vagrantfile`. To destroy it completely (if you want to save a little disk space, or want to rebuild it from scratch with `vagrant up` again), type in `vagrant destroy`.
  - You can change the installed version of Drupal or drush, or any other configuration options, by editing the variables within `vars/main.yml`.
  - Find out more about local development with Vagrant + VirtualBox + Ansible in this presentation: [Local Development Environments - Vagrant, VirtualBox and Ansible](http://www.slideshare.net/geerlingguy/local-development-on-virtual-machines-vagrant-virtualbox-and-ansible).
  - Learn about how Ansible can accelerate your ability to innovate and manage your infrastructure by reading [Ansible for DevOps](https://leanpub.com/ansible-for-devops).

## About the Author

[Jeff Geerling](http://jeffgeerling.com/), owner of [Midwestern Mac, LLC](http://www.midwesternmac.com/), created this project in 2014 so he could accelerate his Drupal core and contrib development workflow. This project, and others like it, are also featured as examples in Jeff's book, [Ansible for DevOps](https://leanpub.com/ansible-for-devops).
