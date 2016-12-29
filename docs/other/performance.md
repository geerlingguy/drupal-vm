## Improving composer build performance

Opting for composer based installs will most likely increase your VM's time to provision considerably.

If you manage multiple VM's own your computer, you can use the [`vagrant-cachier` plugin](http://fgrehm.viewdocs.io/vagrant-cachier/) to share Composer's package cache across all VM's. The first build will be as slow as before but subsequent builds with the same `vagrant_box` (eg `geerlingguy/ubuntu1604`) will be much faster.

Install the plugin on your host computer: `vagrant plugin install vagrant-cachier`.

Drupal VM's `Vagrantfile` includes the appropriate `vagrant-cachier` configuration to cache Composer and apt dependencies.

_You can also use this plugin to share other package manager caches. For more information read the [documentation](http://fgrehm.viewdocs.io/vagrant-cachier/usage/)._
