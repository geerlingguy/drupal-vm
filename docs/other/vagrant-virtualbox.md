From time to time, users have reported particular issues with Vagrant or VirtualBox in certain environments, and this page shows some common issues and possible fixes/solutions.

## Guest additions fail to be detected

From time to time, if you `vagrant halt`, then `vagrant up` again, you might get a message like `No guest additions were detected on the base box for this VM!`, as well as messages about shared folders not working correctly.

There are two ways you can fix this problem:

  1. Make sure you're running the latest box version for Drupal VM. Update by running `vagrant box update`.
  2. Install the `vagrant vbguest` plugin: `vagrant plugin install vagrant-vbguest`.
