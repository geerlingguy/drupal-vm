# Drupal Development VM

This project is a fork of [Jeff Geerling's](https://github.com/geerlingguy) [Drupal Dev VM](https://github.com/geerlingguy/drupal-dev-vm), which aims to make spinning up a simple local Drupal test/development environment incredibly quick and easy. Feel free to consult the original [project readme](README-prefork.md) for further background and information. The essential information from that readme has been copied here.

This project will install the following on an Ubuntu 14.04 linux VM:

  - Apache 2.4.x
  - PHP 5.5.x (configurable)
  - MySQL 5.5.x
  - Drush latest release (configurable)
  - Optional (installed by default):
    - XHProf, for profiling your code
    - XDebug, for debugging your code
    - MailHog, for catching and debugging email

It should take 5-10 minutes to build or rebuild the VM from scratch on a decent broadband connection.

## Customizing the VM

See config.yml for customizing your specific configuration needs. The current configuration is based on the needs of the ILR Web Team for the [ILR School's public site](https://github.com/ilrWebServices/ilr-website).

## Quick Start Guide

### 1 - Install dependencies (VirtualBox, Vagrant, Ansible)

  1. If you've obtained the licenses and keys, download and install [VMWare Fusion Pro](http://www.vmware.com/products/fusion/fusion-evaluation) and the [VMWare Vagrant plugin](https://www.vagrantup.com/vmware). Alternatively, download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads), though this is less performant.
  2. Download and install [Vagrant](http://www.vagrantup.com/downloads.html).
  3. [Mac/Linux only] Install [Ansible](http://docs.ansible.com/intro_installation.html).


### 2 - Build the Virtual Machine

  1. Download this project and put it wherever you want.
  2. Make sure that the appropriate Drupal project is cloned to your local system in the same parent directory as this project and referenced appropriately in config.yml.
  3. Install Ansible Galaxy roles required for this VM: `$ sudo ansible-galaxy install -r requirements.txt`
  4. Open Terminal, cd to this directory (containing the `Vagrantfile` and this README file).
  5. Type in `vagrant up`, and let Vagrant do its magic.

Note: *If there are any errors during the course of running `vagrant up`, and it drops you back to your command prompt, just run `vagrant provision` to continue building the VM from where you left off. If there are still errors after doing this a few times, post an issue to this project's issue queue on GitHub with the error.*

### 3 - Configure your host machine to access the VM.

  1. [Edit your hosts file](http://www.rackspace.com/knowledge_center/article/how-do-i-modify-my-hosts-file), adding the line `192.168.88.89 www.ilr-website.dev` so you can connect to the VM.
  2. Assuming that your key has been added to Acquia, download the db from the ilr-website project via the sync-prod script ([more info](https://github.com/ilrWebServices/ilr-website/blob/master/bin/sync-prod)).
  3. Open your browser and access [http://www.ilr-website.dev/](http://www.ilr-website.dev/).
  4. Follow the setup instructions in the [developer docs](https://github.com/ilrWebServices/ilr-website/blob/master/docs/installation.md) to complete the installation.

## Connecting to MySQL

By default, this VM is set up so you can manage mysql databases on your own. The default root MySQL user credentials are `root` for username+password, but you could change the password via `config.yml`. I use the MySQL GUI [Sequel Pro](http://www.sequelpro.com/) (Mac-only) to connect and manage databases, then Drush to sync databases (sometimes I'll just do a dump and import, but Drush is usually quicker, and is easier to do over and over again when you need it).

### Connect using Sequel Pro (or a similar client):

  1. Use the SSH connection type.
  2. Set the following options:
    - MySQL Host: `127.0.0.1`
    - Username: `root`
    - Password: `root` (or whatever password you chose in `config.yml`)
    - SSH Host: `192.168.88.89` (or whatever IP you chose in `config.yml`)
    - SSH User: `vagrant`
    - SSH Key: (browse to your `~/.vagrant.d/` folder and choose `insecure_private_key`)

You should be able to connect as the root user and add, manage, and remove databases and users.

## Extra utilities

By default, this VM includes the utilities listed in the `config.yml` option `installed_extras`:

    installed_extras:
      - xdebug
      - xhprof
      - mailhog

If you don't want or need one or more of these utilities, just delete them or comment them from the list. This is helpful if you want to reduce PHP memory usage or otherwise conserve system resources.

## Other Notes

  - To shut down the virtual machine, enter `vagrant halt` in the Terminal in the same folder that has the `Vagrantfile`. To destroy it completely (if you want to save a little disk space, or want to rebuild it from scratch with `vagrant up` again), type in `vagrant destroy`.
  - You can change the installed version of Drupal or drush, or any other configuration options, by editing the variables within `vars/main.yml`.
  - Find out more about local development with Vagrant + VirtualBox + Ansible in this presentation: [Local Development Environments - Vagrant, VirtualBox and Ansible](http://www.slideshare.net/geerlingguy/local-development-on-virtual-machines-vagrant-virtualbox-and-ansible).
  - Learn about how Ansible can accelerate your ability to innovate and manage your infrastructure by reading [Ansible for DevOps](https://leanpub.com/ansible-for-devops).
