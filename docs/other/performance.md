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
      - private
      - .git
      - web/sites/default/files
      - tmp
```

### Mixing synced folder types

You can also mix the synced folder types and use a fast one-way rsync for your primary codebase and then a slower but two-way sync for Drupal's configuration sync directory.

```yaml
vagrant_synced_folders:
  - local_path: .
    destination: /var/www/drupal
    type: rsync
    create: true
    excluded_paths:
      - private
      - .git
      - web/sites/default/files
      - tmp
      # Exclude the second synced folder.
      - config/drupal
  # Use a slower but two-way sync for configuration sync directory.
  - local_path: config/drupal
    destination: /var/www/drupal/config/drupal
    type: "" # Or smb/nfs if available
    create: true
```

## Improving performance on Windows

By default, if you use the _NFS_ synced folder type, Vagrant will ignore this directive and use the native (usually slow) VirtualBox shared folder system instead. You can get higher performance by doing one of the following (all of these steps require a full VM reload (`vagrant reload`) to take effect):

  1. **Use PhpStorm or a reverse-mounted synced folder for working from inside the VM.** Read [Drupal VM on Windows - a fast container for BLT project development](https://www.jeffgeerling.com/blog/2017/drupal-vm-on-windows-fast-container-blt-project-development) for instructions and recommendations.
  1. **Install the `vagrant-winnfsd` plugin**. See the 'NFS' section later for more details and caveats.
  1. **Use `smb` for the synced folder's type.**
  1. **Use `rsync` for the synced folder's type.** This requires that you have `rsync` available on your Windows workstation, which you can get if you install a substitute CLI like [Cygwin](https://www.cygwin.com/) or [Cmder](http://cmder.net/).

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

### Better performance: Sharing from Drupal VM to your PC

The fastest option for Drupal VM is to install the Drupal codebase entirely inside Drupal VM, without using a Vagrant shared folder. This method ensures the code runs as fast as it would if it were natively running on your PC, but it requires some other form of codebase synchronization, and means there is at least a tiny bit of lag between saving files in your editor and seeing the changes inside Drupal VM.

If you use one of these techniques, it's recommended you use the [Git deployment technique](../deployment/git.md) to clone your Drupal codebase into Drupal VM from a Git repository.

#### Syncing files via rsync or SSH

If you use an IDE like PhpStorm, you can configure it to synchronize a local codebase with the code inside Drupal VM using SSH (SFTP). There are also tools that mount directories into Windows Explorer using plain SSH and SFTP, though configuring these tools can be difficult.

If at all possible, make sure your IDE is configured to automatically synchronize changes.

#### Share files using Samba inside Drupal VM

Though it's not supported natively by Vagrant, you can mount a Samba share _from the VM guest_ to your host PC. To do this, you have to:

  1. Install Samba inside the VM.
  2. Configure Samba (through `smb.conf`) to share a directory inside the VM.
  3. Open firewall ports `137`, `138`, `139`, and `445`.
  4. Mount the Samba shared folder within Windows Explorer (e.g. visit `\\drupalvm.dev\share_name`)

Read this blog post for further detail in creating a Samba share: [Configure a reverse-mounted Samba shared folder](https://www.jeffgeerling.com/blog/2017/drupal-vm-on-windows-fast-container-blt-project-development#reverse-share).
