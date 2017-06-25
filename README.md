![Drupal VM Logo](https://raw.githubusercontent.com/geerlingguy/drupal-vm/master/docs/images/drupal-vm-logo.png)

[![Build Status](https://travis-ci.org/geerlingguy/drupal-vm.svg?branch=master)](https://travis-ci.org/geerlingguy/drupal-vm) [![Documentation Status](https://readthedocs.org/projects/drupal-vm/badge/?version=latest)](http://docs.drupalvm.com) [![Packagist](https://img.shields.io/packagist/v/geerlingguy/drupal-vm.svg)](https://packagist.org/packages/geerlingguy/drupal-vm) [![Docker Automated build](https://img.shields.io/docker/automated/geerlingguy/drupal-vm.svg?maxAge=2592000)](https://hub.docker.com/r/geerlingguy/drupal-vm/) [![](https://images.microbadger.com/badges/image/geerlingguy/drupal-vm.svg)](https://microbadger.com/images/geerlingguy/drupal-vm "Get your own image badge on microbadger.com") [![irc://irc.freenode.net/drupal-vm](https://img.shields.io/badge/irc.freenode.net-%23drupal--vm-brightgreen.svg)](https://riot.im/app/#/room/#drupal-vm:matrix.org)

[Drupal VM](https://www.drupalvm.com/) is A VM for Drupal, built with Ansible.

Drupal VM makes building Drupal development environments quick and easy, and introduces developers to the wonderful world of Drupal development on virtual machines or Docker containers (instead of crufty old MAMP/WAMP-based development).

It will install the following on an Ubuntu 16.04 (by default) linux VM:

  - Apache 2.4.x (or Nginx)
  - PHP 7.1.x (configurable)
  - MySQL 5.7.x (or MariaDB, or PostgreSQL)
  - Drupal 7 or 8
  - Optional:
    - Drupal Console
    - Drush
    - Varnish 4.x (configurable)
    - Apache Solr 4.10.x (configurable)
    - Elasticsearch
    - Node.js 0.12 (configurable)
    - Selenium, for testing your sites via Behat
    - Ruby
    - Memcached
    - Redis
    - SQLite
    - Blackfire, XHProf, or Tideways for profiling your code
    - XDebug, for debugging your code
    - Adminer, for accessing databases directly
    - Pimp my Log, for easy viewing of log files
    - MailHog, for catching and debugging email

It should take 5-10 minutes to build or rebuild the VM from scratch on a decent broadband connection.

Please read through the rest of this README and the [Drupal VM documentation](http://docs.drupalvm.com/) for help getting Drupal VM configured and integrated with your workflow.

## Documentation

Full Drupal VM documentation is available at http://docs.drupalvm.com/

## Customizing the VM

There are a couple places where you can customize the VM for your needs:

  - `config.yml`: Override any of the default VM configuration from `default.config.yml`; customize almost any aspect of any software installed in the VM (more about [configuring Drupal VM](http://docs.drupalvm.com/en/latest/getting-started/configure-drupalvm/).
  - `drupal.composer.json` or `drupal.make.yml`: Contains configuration for the Drupal core version, modules, and patches that will be downloaded on Drupal's initial installation (you can build using Composer, Drush make, or your own codebase).

If you want to switch from Drupal 8 (default) to Drupal 7 on the initial install, do the following:

  1. Switch to using a [Drush Make file](http://docs.drupalvm.com/en/latest/deployment/drush-make/).
  1. Update the Drupal `version` and `core` inside your `drupal.make.yml` file.
  2. Set `drupal_major_version: 7` inside `config.yml`.

## Quick Start Guide

This Quick Start Guide will help you quickly build a Drupal 8 site on the Drupal VM using Composer with `drupal-project`. You can also use Drupal VM with [Composer](http://docs.drupalvm.com/en/latest/deployment/composer/), a [Drush Make file](http://docs.drupalvm.com/en/latest/deployment/drush-make/), with a [Local Drupal codebase](http://docs.drupalvm.com/en/latest/deployment/local-codebase/), or even a [Drupal multisite installation](http://docs.drupalvm.com/en/latest/deployment/multisite/).

If you want to install a Drupal 8 site locally with minimal fuss, just:

  1. Install [Vagrant](https://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads).
  2. Download or clone this project to your workstation.
  3. `cd` into this project directory and run `vagrant up`.

But Drupal VM allows you to build your site exactly how you like, using whatever tools you need, with almost infinite flexibility and customization!

### 1 - Install Vagrant and VirtualBox

Download and install [Vagrant](https://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads).

You can also use an alternative provider like Parallels or VMware. (Parallels Desktop 11+ requires the "Pro" or "Business" edition and the [Parallels Provider](http://parallels.github.io/vagrant-parallels/), and VMware requires the paid [Vagrant VMware integration plugin](http://www.vagrantup.com/vmware)).

Notes:

  - **For faster provisioning** (macOS/Linux only): *[Install Ansible](http://docs.ansible.com/intro_installation.html) on your host machine, so Drupal VM can run the provisioning steps locally instead of inside the VM.*
  - **For stability**: Because every version of VirtualBox introduces changes to networking, for the best stability, you should install Vagrant's `vbguest` plugin: `vagrant plugin install vagrant-vbguest`.
  - **NFS on Linux**: *If NFS is not already installed on your host, you will need to install it to use the default NFS synced folder configuration. See guides for [Debian/Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-14-04), [Arch](https://wiki.archlinux.org/index.php/NFS#Installation), and [RHEL/CentOS](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-centos-6).*
  - **Versions**: *Make sure you're running the latest releases of Vagrant, VirtualBox, and Ansible—as of late 2016, Drupal VM recommends: Vagrant 1.8.6, VirtualBox 5.1.10+, and Ansible 2.2.x*

### 2 - Build the Virtual Machine

  1. Download this project and put it wherever you want.
  2. (Optional) Copy `default.config.yml` to `config.yml` and modify it to your liking.
  3. Create a local directory where Drupal will be installed and configure the path to that directory in `config.yml` (`local_path`, inside `vagrant_synced_folders`).
  4. Open Terminal, `cd` to this directory (containing the `Vagrantfile` and this README file).
  5. Type in `vagrant up`, and let Vagrant do its magic.

Once the process is complete, you will have a Drupal codebase available inside the `drupal/` directory of the project.

Note: *If there are any errors during the course of running `vagrant up`, and it drops you back to your command prompt, just run `vagrant provision` to continue building the VM from where you left off. If there are still errors after doing this a few times, post an issue to this project's issue queue on GitHub with the error.*

### 3 - Access the VM.

Open your browser and access [http://drupalvm.dev/](http://drupalvm.dev/). The default login for the admin account is `admin` for both the username and password.

Note: *By default Drupal VM is configured to use `192.168.88.88` as its IP, if you're running multiple VM's the `auto_network` plugin (`vagrant plugin install vagrant-auto_network`) can help with IP address management if you set `vagrant_ip` to `0.0.0.0` inside `config.yml`.*

## Extra software/utilities

By default, this VM includes the extras listed in the `config.yml` option `installed_extras`:

    installed_extras:
      - adminer
      # - blackfire
      # - drupalconsole
      - drush
      # - elasticsearch
      # - java
      - mailhog
      # - memcached
      # - newrelic
      # - nodejs
      - pimpmylog
      # - redis
      # - ruby
      # - selenium
      # - solr
      # - tideways
      # - upload-progress
      - varnish
      # - xdebug
      # - xhprof

If you don't want or need one or more of these extras, just delete them or comment them from the list. This is helpful if you want to reduce PHP memory usage or otherwise conserve system resources.

## Using Drupal VM

Drupal VM is built to integrate with every developer's workflow. Many guides for using Drupal VM for common development tasks are available on the [Drupal VM documentation site](http://docs.drupalvm.com).

## Updating Drupal VM

Drupal VM follows semantic versioning, which means your configuration should continue working (potentially with very minor modifications) throughout a major release cycle. Here is the process to follow when updating Drupal VM between minor releases:

  1. Read through the [release notes](https://github.com/geerlingguy/drupal-vm/releases) and add/modify `config.yml` variables mentioned therein.
  2. Do a diff of your `config.yml` with the updated `default.config.yml` (e.g. `curl https://raw.githubusercontent.com/geerlingguy/drupal-vm/master/default.config.yml | git diff --no-index config.yml -`).
  3. Run `vagrant provision` to provision the VM, incorporating all the latest changes.

For major version upgrades (e.g. 2.x.x to 3.x.x), it may be simpler to destroy the VM (`vagrant destroy`) then build a fresh new VM (`vagrant up`) using the new version of Drupal VM.

## System Requirements

Drupal VM runs on almost any modern computer that can run VirtualBox and Vagrant, however for the best out-of-the-box experience, it's recommended you have a computer with at least:

  - Intel Core processor with VT-x enabled
  - At least 4 GB RAM (higher is better)
  - An SSD (for greater speed with synced folders)

## Other Notes

  - To shut down the virtual machine, enter `vagrant halt` in the Terminal in the same folder that has the `Vagrantfile`. To destroy it completely (if you want to save a little disk space, or want to rebuild it from scratch with `vagrant up` again), type in `vagrant destroy`.
  - To log into the virtual machine, enter `vagrant ssh`. You can also get the machine's SSH connection details with `vagrant ssh-config`.
  - When you rebuild the VM (e.g. `vagrant destroy` and then another `vagrant up`), make sure you clear out the contents of the `drupal` folder on your host machine, or Drupal will return some errors when the VM is rebuilt (it won't reinstall Drupal cleanly).
  - You can change the installed version of Drupal or drush, or any other configuration options, by editing the variables within `config.yml`.
  - Find out more about local development with Vagrant + VirtualBox + Ansible in this presentation: [Local Development Environments - Vagrant, VirtualBox and Ansible](http://www.slideshare.net/geerlingguy/local-development-on-virtual-machines-vagrant-virtualbox-and-ansible).
  - Learn about how Ansible can accelerate your ability to innovate and manage your infrastructure by reading [Ansible for DevOps](http://www.ansiblefordevops.com/).

## Tests

To run basic integration tests using Docker:

  1. [Install Docker](https://docs.docker.com/engine/installation/).
  2. In this project directory, run: `composer run-tests`

> Note: If you're on a Mac, you need to use [Docker's Edge release](https://docs.docker.com/docker-for-mac/install/#download-docker-for-mac), at least until [this issue](https://github.com/docker/for-mac/issues/77) is resolved.

The project's automated tests are run via Travis CI, and the more comprehensive test suite covers multiple Linux distributions and many different Drupal VM use cases and deployment techniques.

## License

This project is licensed under the MIT open source license.

## About the Author

[Jeff Geerling](https://www.jeffgeerling.com/) created Drupal VM in 2014 for a more efficient Drupal site and core/contrib development workflow. This project is featured as an example in [Ansible for DevOps](https://www.ansiblefordevops.com/).
