There are a few caveats when using Drupal VM on Windows, and this page will try to identify the main gotchas or optimization tips for those wishing to use Drupal VM on a Windows host.

## Synced Folders

Most issues have to do synced folders. These are the most common ones:

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
