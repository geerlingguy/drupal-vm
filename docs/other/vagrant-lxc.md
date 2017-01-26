[`vagrant-lxc` is a Vagrant plugin](https://github.com/fgrehm/vagrant-lxc) that provisions Linux Containers (LXC) rather than VM's such as VirtualBox or VMWare. Although LXC has much better performance, it only works on Linux hosts, and it isn't as well supported or tested by Drupal VM.

### Install dependencies

    sudo apt-get install lxc bridge-utils
    vagrant plugin install vagrant-lxc

### Load required kernel modules

As containers can't load modules, but inherit them from the host, you need to load these on your host machine.

    sudo modprobe iptable_filter
    sudo modprobe ip6table_filter

To load these automatically when you boot up your system, you should check the guidelines of your specific distribution. Usually you add them to `/etc/modules` or `/etc/modules-load.d/*`

### Create a [`Vagrantfile.local`](../extending/vagrantfile.md)

    config.vm.networks[0][1][:lxc__bridge_name] = 'vlxcbr1'
    config.vm.provider :lxc do |lxc|
      lxc.customize 'cgroup.memory.limit_in_bytes', "#{vconfig['vagrant_memory']}M"
    end

Read more about how to configure the container in [`vagrant-lxc`'s README.md](https://github.com/fgrehm/vagrant-lxc#readme).

### Modify your `config.yml`

The following boxes have been tested only minimally, choose which one you want.

    # Centos 7
    vagrant_box: frensjan/centos-7-64-lxc

    # Ubuntu 16.04
    vagrant_box: nhinds/xenial64

    # Do not interact with the UFW service on Ubuntu.
    drupalvm_disable_ufw_firewall: false

### Provision the Container

    vagrant up --provider=lxc
