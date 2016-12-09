There are a few caveats when using Drupal VM on Windows, and this page will try to identify the main gotchas or optimization tips for those wishing to use Drupal VM on a Windows host.

## Windows Subsystem for Linux / Ubuntu bash

If you are running Windows 10 (Anniversary edition) or later, you can install the Windows Subsytem for Linux, which allows you to install an Ubuntu-based CLI inside of Windows. With this installed, you can then manage and run Drupal VM inside the Linux-like environment. Follow these steps to use Drupal VM in the WSL:

  1. Install Vagrant and VirtualBox in Windows (links in the [Drupal VM Quick Start Guide](https://github.com/geerlingguy/drupal-vm#quick-start-guide)).
  2. [Install/Enable the Windows Subsystem for Linux](https://msdn.microsoft.com/en-us/commandline/wsl/install_guide).
    1. Create an admin account for the Ubuntu Bash environment when prompted.
  3. In a local copy of Drupal VM (downloaded or Git cloned into a path that's in the Windows filesystem, e.g. `/mnt/c/Users/yourusername/Sites/drupal-vm`), run `wrun vagrant up`.

If you need to run any other `vagrant` commands (with the exception of `vagrant ssh`—for now, that must be run in a different environment; see [Vagrant: Use Linux Subsystem on Windows](https://github.com/mitchellh/vagrant/issues/7731)), you can do so by prefixing them with `wrun`.

> Note: using `wrun`, interactive prompts don't seem to work (e.g. if you run `vagrant destroy` without `-f`, you have to Ctrl-C out of it because it just hangs).
>
> Note 2: that the WSL is still in beta, and tools like `cbwin` are still undergoing rapid development, so some of these instructions are subject to change!

## Command line environment

If you're not on Windows 10, or if you don't want to install the WSL, you can use PowerShell, Git Bash, Git Shell, or other PowerShell-based environments with Drupal VM and Vagrant; however you might want to consider using a more POSIX-like environment so you can more easily work with Drupal VM:

  - [Cmder](http://cmder.net/) includes built-in git and SSH support, so you can do most things that you need without any additional plugins.
  - [Cygwin](https://www.cygwin.com/) allows you to install a large variety of linux packages inside its bash environment, though it can be a little more tricky to manage and is less integrated into the Windows environment.

## Synced Folders

Most issues have to do synced folders. These are the most common ones:

### Performance

By default, if you use the 'NFS' synced folder type, Vagrant will ignore this directive and use the native (usually slow) VirtualBox shared folder system instead. You can get higher performance by doing one of the following (all of these steps require a full VM reload (`vagrant reload`) to take effect):

  1. **Install the `vagrant-winnfsd` plugin**. See the 'NFS' section later for more details and caveats.
  2. **Use `smb` for the synced folder's type.**
  2. **Use `rsync` for the synced folder's type.** This requires that you have `rsync` available on your Windows workstation, which you can get if you install a substitute CLI like [Cygwin](https://www.cygwin.com/) or [Cmder](http://cmder.net/).

### Symbolic Links

Creating symbolic links in a shared folder will fail with a permission or protocol error.

There are two parts to this:

  1. VirtualBox does not allow gets VMs to create symlinks in synced folders by default.
  2. Windows does not allow the creation of symlinks unless your local policy allows it; see [TechNet article](https://technet.microsoft.com/en-us/library/dn221947%28v=ws.10%29.aspx). Even if local policy allows it, many users experience problems in the creation of symlinks.

Using Ubuntu bash under Windows 10 _can_ make this easier, but there are still issues when creating and managing symlinks between the bash environment and the guest Vagrant operating system.

### Git and File permissions

If you're using a synced folder for your project, you should choose to either work _only_ inside the VM, or _only_ on the host machine. Don't commit changes both inside the VM and on the host unless you know what you're doing and have Git configured properly for Unix vs. Windows line endings. File permissions and line endings can be changed in ways that can break your project if you're not careful!

You should probably disable Git's `fileMode` option inside the VM and on your host machine if you're running Windows and making changes to a Git repository:

    git config core.fileMode false

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

### "Authentication failure" on vagrant up

Some Windows users have reported running into an issue where an authentication failure is reported once the VM is booted (e.g. `drupalvm: Warning: Authentication failure. Retrying...` — see [#170](https://github.com/geerlingguy/drupal-vm/issues/170)). To fix this, do the following:

  1. Delete `~/.vagrant.d/insecure_private_key`
  2. Run `vagrant ssh-config`
  3. Restart the VM with `vagrant reload`

### Windows 7 requires PowerShell upgrade

If you are running Windows 7 and `vagrant up` hangs, you may need to upgrade PowerShell. Windows 7 ships with PowerShell 2.0, but PowerShell 3.0 or higher is required. For Windows 7, you can upgrade to PowerShell 4.0 which is part of the [Windows Management Framework](http://www.microsoft.com/en-us/download/details.aspx?id=40855).

## Hosts file updates

If you install either the `vagrant-hostsupdater` or `vagrant-hostmanager` plugin, you might get a permissions error when Vagrant tries changing the hosts file. On a macOS or Linux workstation, you're prompted for a sudo password so the change can be made, but on Windows, you have to do one of the following to make sure hostsupdater works correctly:

  1. Run PowerShell or whatever CLI you use with Vagrant as an administrator. Right click on the application and select 'Run as administrator', then proceed with `vagrant` commands as normal.
  2. Change the permissions on the hosts file so your account has permission to edit the file (this has security implications, so it's best to use option 1 unless you know what you're doing). To do this, open `%SystemRoot%\system32\drivers\etc` in Windows Explorer, right-click the `hosts` file, and under Security, add your account and give yourself full access to the file.

## Intel VT-x virtualization support

On some laptops, Intel VT-x virtualization (which is built into most modern Intel processors) is enabled by default. This allows VirtualBox to run virtual machines efficiently using the CPU itself instead of software CPU emulation. If you get a message like "VT-x is disabled in the bios for both all cpu modes" or something similar, you may need to enter your computer's BIOS settings and enable this virtualization support.
