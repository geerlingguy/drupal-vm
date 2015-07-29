Since Vagrant manages internal network connections for Drupal VM, and since every person's network setup is unique, there are sometimes networking issues that require some adjustments to your Drupal VM configuration or a computer reboot.

## Network Route Collision

Drupal VM comes configured with the default IP address `192.168.88.88`. If you're connected to a LAN with the same private IP address range (e.g. `192.168.x.x`), then VirtualBox or VMware will not be able to set up the VM with the default IP address, because that would conflict with the `192.168.x.x` network your computer is using.

In this case, you have two options:

  1. Switch the `vagrant_ip` in `config.yml` to a different private IP address, e.g. `172.16.0.88` or `10.0.1.88`.
  2. Install the `vagrant-auto_network` plugin (`vagrant plugin install vagrant-auto_network`), and set the `vagrant_ip` to `0.0.0.0`.

Another cause of route collisions is the use of multiple VM providers on your computer. If you have both VirtualBox and VMware Fusion, and you have VMs running in both, and you attempt to use the same IP range in both providers, you'll hit a networking conflict. In this case, the only easy way to restore connectivity is to restart your host machine.
