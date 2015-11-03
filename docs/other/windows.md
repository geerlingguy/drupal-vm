There are a few caveats when using Drupal VM on Windows, and this page will try to identify the main gotchas or optimization tips for those wishing to use Drupal VM on a Windows host.

## Synced Folders

Most issues have to do synced folders. These are the most common ones:

### Performance

By default, if you use the 'NFS' synced folder type, Vagrant will ignore this directive and use the native (usually slow) VirtualBox shared folder system instead. You can get higher performance by doing one of the following (all of these steps require a full VM reload (`vagrant reload`) to take effect):

  1. **Install the `vagrant-winnfsd` plugin**. See the 'NFS' section later for more details and caveats.
  2. **Use `smb` for the synced folder's type.**
  2. **Use `rsync` for the synced folder's type.** This requires that you have `rsync` available on your Windows workstation, which you can get if you install a substitute CLI like [Cygwin](https://www.cygwin.com/).

### Symbolic Links

Creating symbolic links in a shared folder will fail with a permission or protocol error.

There are two parts to this:

  1. VirtualBox does not allow gets VMs to create symlinks in synced folders by default.
  2. Windows does not allow the creation of symlinks unless your local policy allows it; see [TechNet article](https://technet.microsoft.com/en-us/library/dn221947%28v=ws.10%29.aspx). Even if local policy allows it, many users experience problems in the creation of symlinks.

### Git and File permissions

If you're using a synced folder for your project, you should choose to either work _only_ inside the VM, or _only_ on the host machine. Don't commit changes both inside the VM and on the host unless you know what you're doing and have Git configured properly for Unix vs. Windows line endings. File permissions and line endings can be changed in ways that can break your project if you're not careful!

You should probably disable Git's `fileMode` option inside the VM and on your host machine if you're running Windows and making changes to a Git repository:

    git config core.fileMode false

### Long Paths

Creating long paths inside a shared folder will fail if the length exceeds 260 characters. This usually happens when using npm. This should be solved in Vagrant 1.7.3, but if you're running an older version, you can manually make the changes here: https://github.com/mitchellh/vagrant/pull/5495/files

### NFS

You can use the [vagrant-winnfsd](https://github.com/GM-Alex/vagrant-winnfsd) plugin to get NFS support on windows. Be aware that there are multiple issues logged against both the plugin and the winnfsd project, so no guarantees.

### "Authentication failure" on vagrant up

Some Windows users have reported running into an issue where an authentication failure is reported once the VM is booted (e.g. `drupalvm: Warning: Authentication failure. Retrying...` — see [#170](https://github.com/geerlingguy/drupal-vm/issues/170)). To fix this, do the following:

  1. Delete `~/.vagrant.d/insecure_private_key`
  2. Run `vagrant ssh-config`
  3. Restart the VM with `vagrant reload`

### Windows 7 requires PowerShell upgrade

If you are running Windows 7 and `vagrant up` hangs, you may need to upgrade PowerShell. Windows 7 ships with PowerShell 2.0, but PowerShell 3.0 or higher is required. For Windows 7, you can upgrade to PowerShell 4.0 which is part of the [Windows Management Framework](http://www.microsoft.com/en-us/download/details.aspx?id=40855).

## Hosts file updates

If you install the `vagrant-hostsupdater` plugin, you might get a permissions error when Vagrant tries changing the hosts file. On a Mac or Linux workstation, you're prompted for a sudo password so the change can be made, but on Windows, you have to do one of the following to make sure hostsupdater works correctly:

  1. Run PowerShell or whatever CLI you use with Vagrant as an administrator. Right click on the application and select 'Run as administrator', then proceed with `vagrant` commands as normal.
  2. Change the permissions on the hosts file so anyone can edit the file (this has security implications, so it's best to use option 1 unless you know what you're doing).

## Intel VT-x virtualization support

On some laptops, Intel VT-x virtualization (which is built into most modern Intel processors) is enabled by default. This allows VirtualBox to run virtual machines efficiently using the CPU itself instead of software CPU emulation. If you get a message like "VT-x is disabled in the bios for both all cpu modes" or something similar, you may need to enter your computer's BIOS settings and enable this virtualization support.
