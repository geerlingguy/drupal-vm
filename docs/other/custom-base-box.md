You can build a custom Vagrant base box to help speed up the provisioning time for Drupal VM for your project, or if you have other specilized requirements, like:

  - You need larger virtual disk image size for your VM
  - You need a base box for a provider not supported by the default Drupal VM boxes (e.g. Parallels, VMware Fusion, AWS, etc.)
  - You need to inject certain software or configuration which is difficult to do using Drupal VM alone.

By default, Drupal VM uses the [`geerlingguy/drupal-vm`](https://app.vagrantup.com/geerlingguy/boxes/drupal-vm) Vagrant base box, but you can use any base box which has at least a minimal OS installation supported by Drupal VM (e.g. CentOS, Ubuntu, Debian).

This base box is built using the Packer configuration here: [Packer Build - Drupal VM](https://github.com/geerlingguy/packer-drupal-vm).

In order to build your own custom base box, fork the Packer project linked above, then follow the instructions included in its README to install Packer and build the base box. Then update your `config.yml` to point to your own custom box by overriding the `vagrant_box` variable.
