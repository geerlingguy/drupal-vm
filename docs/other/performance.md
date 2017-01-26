## Improving composer build performance

Opting for composer based installs will most likely increase your VM's time to provision considerably.

If you manage multiple VM's own your computer, you can use the [`vagrant-cachier` plugin](http://fgrehm.viewdocs.io/vagrant-cachier/) to share Composer's package cache across all VM's. The first build will be as slow as before but subsequent builds with the same `vagrant_box` (eg `geerlingguy/ubuntu1604`) will be much faster.

Install the plugin on your host computer: `vagrant plugin install vagrant-cachier`.

Drupal VM's `Vagrantfile` includes the appropriate `vagrant-cachier` configuration to cache Composer and apt dependencies.

_You can also use this plugin to share other package manager caches. For more information read the [documentation](http://fgrehm.viewdocs.io/vagrant-cachier/usage/)._

## Synced Folder Performance

Using different synced folder mechanisms can have a dramatic impact on your Drupal site's performance. Please read through the following blog posts for a thorough overview of synced folder performance:

  - [Comparing filesystem performance in Virtual Machines](http://mitchellh.com/comparing-filesystem-performance-in-virtual-machines)
  - [NFS, rsync, and shared folder performance in Vagrant VMs](http://www.jeffgeerling.com/blogs/jeff-geerling/nfs-rsync-and-shared-folder)

Generally speaking:

  - NFS offers a decent tradeoff between performance and ease of use
  - SMB offers a similar tradeoff, but is a bit slower than NFS
  - Rsync offers the best performance inside the VM, but sync is currently one-way-only (from host to VM), which can make certain development workflows burdensome
  - Native shared folders offer abysmal performance; only use this mechanism as a last resort!

If you are using rsync, it is advised to exclude certain directories so that they aren't synced. These include version control directories, database exports and Drupal's files directory.

```yaml
vagrant_synced_folders:
  - local_path: .
    destination: /var/www/drupalvm
    type: rsync
    create: true
    excluded_paths:
      - drupal/private
      - drupal/public/.git
      - drupal/public/sites/default/files
      - drupal/tmp
```

_This example assumes that you have Drupal in a directory called `drupal/public`._


## Improving performance on Windows

By default, if you use the _NFS_ synced folder type, Vagrant will ignore this directive and use the native (usually slow) VirtualBox shared folder system instead. You can get higher performance by doing one of the following (all of these steps require a full VM reload (`vagrant reload`) to take effect):

  1. **Install the `vagrant-winnfsd` plugin**. See the 'NFS' section later for more details and caveats.
  2. **Use `smb` for the synced folder's type.**
  2. **Use `rsync` for the synced folder's type.** This requires that you have `rsync` available on your Windows workstation, which you can get if you install a substitute CLI like [Cygwin](https://www.cygwin.com/) or [Cmder](http://cmder.net/).

### NFS

You can use the [vagrant-winnfsd](https://github.com/GM-Alex/vagrant-winnfsd) plugin to get NFS support on windows. Be aware that there are multiple issues logged against both the plugin and the winnfsd project, so no guarantees.

#### Using WinNFSD without `vagrant-winnfsd`

Another option for the more adventurous is to manually install and configure WinNFSD, and manually mount the shares within your VM. This requires a bit more work, but could be more stable on Windows; see this blog post for more details: [Windows + Vagrant + WinNFSD without file update problems](https://hollyit.net/blog/windowsvagrantwinnfsd-without-file-update-problems).

GuyPaddock's [fork of `vagrant-winnfsd`](https://github.com/GuyPaddock/vagrant-winnfsd) adds logging and debug messages. You can replace the vagrant-winnfsd gem inside `.vagrant.d\gems\gems` to use it instead. For further caveats, please read through [vagrant-winnfsd issue #12](https://github.com/winnfsd/vagrant-winnfsd/issues/12#issuecomment-78195957), and make the following changes to `config.yml`:

    vagrant_synced_folder_default_type: ""

Add `mount_options` to your synced folder to avoid an error:

    type: nfs
    mount_options: ["rw","vers=3","udp","nolock"]

In a custom `Vagrantfile.local`, add user access to Vagrant:

    config.winnfsd.uid=900
    config.winnfsd.gid=900
