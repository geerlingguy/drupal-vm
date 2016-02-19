![Drupal VM Logo](https://raw.githubusercontent.com/geerlingguy/drupal-vm/master/docs/images/drupal-vm-logo.png)

[![Build Status](https://travis-ci.org/geerlingguy/drupal-vm.svg?branch=master)](https://travis-ci.org/geerlingguy/drupal-vm) [![Documentation Status](https://readthedocs.org/projects/drupal-vm/badge/?version=latest)](http://docs.drupalvm.com)

[Drupal VM](http://www.drupalvm.com/) is A VM for local Drupal development, built with Vagrant + Ansible.

This project aims to make spinning up a simple local Drupal test/development environment incredibly quick and easy, and to introduce new developers to the wonderful world of Drupal development on local virtual machines (instead of crufty old MAMP/WAMP-based development).

It will install the following on an Ubuntu 14.04 (by default) linux VM:

  - Apache 2.4.x (or Nginx 1.x)
  - PHP 5.6.x (configurable)
  - MySQL 5.5.x
  - Drush (configurable)
  - Drupal 6.x, 7.x, or 8.x.x (configurable)
  - Optional:
    - Drupal Console
    - Varnish 4.x (configurable)
    - Apache Solr 4.10.x (configurable)
    - Node.js 0.12 (configurable)
    - Selenium, for testing your sites via Behat
    - Ruby
    - Memcached
    - Redis
    - XHProf, for profiling your code
    - XDebug, for debugging your code
    - Adminer, for accessing databases directly
    - Pimp my Log, for easy viewing of log files
    - MailHog, for catching and debugging email

It should take 5-10 minutes to build or rebuild the VM from scratch on a decent broadband connection.

Please read through the rest of this README and the [Drupal VM documentation](http://docs.drupalvm.com/) for help getting Drupal VM configured and integrated with your development workflow.

## Documentation

Full Drupal VM documentation is available at http://docs.drupalvm.com/

## Customizing the VM

There are a couple places where you can customize the VM for your needs:

  - `config.yml`: Contains variables like the VM domain name and IP address, PHP and MySQL configuration, etc.
  - `drupal.make.yml`: Contains configuration for the Drupal core version, modules, and patches that will be downloaded on Drupal's initial installation (more about [Drush make files](https://www.drupal.org/node/1432374)).

If you want to switch from Drupal 8 (default) to Drupal 7 or 6 on the initial install, do the following:

  1. Update the Drupal `version` and `core` inside the `drupal.make.yml` file.
  2. Update `drupal_major_version` inside `config.yml`.

## Quick Start Guide

This Quick Start Guide will help you quickly build a Drupal 8 site on the Drupal VM using the included example Drush make file. You can also use the Drupal VM with a [Local Drupal codebase](http://docs.drupalvm.com/en/latest/deployment/local-codebase/) or even a [Drupal multisite installation](http://docs.drupalvm.com/en/latest/deployment/multisite/).

### 1 - Install dependencies (Vagrant)

Download and install [Vagrant](https://www.vagrantup.com/downloads.html).
- Vagrant will automatically install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) if no providers are available (Drupal VM also works with Parallels or VMware, if you have the [Vagrant VMware integration plugin](http://www.vagrantup.com/vmware)).

Note for Faster Provisioning (Mac/Linux only): *[Install Ansible](http://docs.ansible.com/intro_installation.html) on your host machine, so Drupal VM can run the provisioning steps locally instead of inside the VM.*

Note for Linux users: *If NFS is not already installed on your host, you will need to install it to use the default NFS synced folder configuration. See guides for [Debian/Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-14-04), [Arch](https://wiki.archlinux.org/index.php/NFS#Installation), and [RHEL/CentOS](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-centos-6).*

Note on versions: *Please make sure you're running the latest stable version of Vagrant, VirtualBox, and Ansible, as the current version of Drupal VM is tested with the latest releases. As of February 2016: Vagrant 1.8.1, VirtualBox 5.0.14, and Ansible 2.0.0.*

### 2 - Build the Virtual Machine

  1. Download this project and put it wherever you want.
  2. Make copies of both of the `example.*` files, and modify to your liking:
    - Copy `example.drupal.make.yml` to `drupal.make.yml`.
    - Copy `example.config.yml` to `config.yml`.
  3. Create a local directory where Drupal will be installed and configure the path to that directory in `config.yml` (`local_path`, inside `vagrant_synced_folders`).
  4. Open Terminal, cd to this directory (containing the `Vagrantfile` and this README file).
  5. (If you have Ansible installed on Mac/Linux) Run `$ sudo ansible-galaxy install -r provisioning/requirements.yml --force`.
  6. Type in `vagrant up`, and let Vagrant do its magic.

Note: *If there are any errors during the course of running `vagrant up`, and it drops you back to your command prompt, just run `vagrant provision` to continue building the VM from where you left off. If there are still errors after doing this a few times, post an issue to this project's issue queue on GitHub with the error.*

### 3 - Configure your host machine to access the VM.

  1. [Edit your hosts file](http://www.rackspace.com/knowledge_center/article/how-do-i-modify-my-hosts-file), adding the line `192.168.88.88  drupalvm.dev` so you can connect to the VM.
    - You can have Vagrant automatically configure your hosts file if you install the `hostsupdater` plugin (`vagrant plugin install vagrant-hostsupdater`). All hosts defined in `apache_vhosts` or `nginx_hosts` will be automatically managed. The `vagrant-hostmanager` plugin is also supported.
    - You can also have Vagrant automatically assign an available IP address to your VM if you install the `auto_network` plugin (`vagrant plugin install vagrant-auto_network`), and set `vagrant_ip` to `0.0.0.0` inside `config.yml`.
  2. Open your browser and access [http://drupalvm.dev/](http://drupalvm.dev/). The default login for the admin account is `admin` for both the username and password.

## Extra software/utilities

By default, this VM includes the extras listed in the `config.yml` option `installed_extras`:

    installed_extras:
      - adminer
      - drupalconsole
      - mailhog
      - memcached
      # - nodejs
      - pimpmylog
      # - redis
      # - ruby
      # - selenium
      # - solr
      - varnish
      - xdebug
      - xhprof

If you don't want or need one or more of these extras, just delete them or comment them from the list. This is helpful if you want to reduce PHP memory usage or otherwise conserve system resources.

## Using Drupal VM

Drupal VM is built to integrate with every developer's workflow. Many guides for using Drupal VM for common development tasks are available on the [Drupal VM documentation site](http://docs.drupalvm.com).

## System Requirements

Drupal VM runs on almost any modern computer that can run VirtualBox and Vagrant, however for the best out-of-the-box experience, it's recommended you have a computer with at least:

  - Intel Core i5, i7 or better processor
  - At least 4 GB RAM (higher is better)
  - An SSD (for greater speed with synced folders)

If you have an older processor or a processor without VT-x virtualization support (e.g. the i3), you can still use Drupal VM, but you will need to switch the `vagrant_box` in `config.yml` to use a 3rd party 32-bit box, like `ubuntu/trusty32` or `hashicorp/precise32`.

## Other Notes

  - To shut down the virtual machine, enter `vagrant halt` in the Terminal in the same folder that has the `Vagrantfile`. To destroy it completely (if you want to save a little disk space, or want to rebuild it from scratch with `vagrant up` again), type in `vagrant destroy`.
  - When you rebuild the VM (e.g. `vagrant destroy` and then another `vagrant up`), make sure you clear out the contents of the `drupal` folder on your host machine, or Drupal will return some errors when the VM is rebuilt (it won't reinstall Drupal cleanly).
  - You can change the installed version of Drupal or drush, or any other configuration options, by editing the variables within `config.yml`.
  - Find out more about local development with Vagrant + VirtualBox + Ansible in this presentation: [Local Development Environments - Vagrant, VirtualBox and Ansible](http://www.slideshare.net/geerlingguy/local-development-on-virtual-machines-vagrant-virtualbox-and-ansible).
  - Learn about how Ansible can accelerate your ability to innovate and manage your infrastructure by reading [Ansible for DevOps](http://www.ansiblefordevops.com/).

## License

This project is licensed under the MIT open source license.

## About the Author

[Jeff Geerling](http://www.jeffgeerling.com/), owner of [Midwestern Mac, LLC](http://www.midwesternmac.com/), created this project in 2014 so he could accelerate his Drupal core and contrib development workflow. This project, and others like it, are also featured as examples in Jeff's book, [Ansible for DevOps](http://www.ansiblefordevops.com/).
