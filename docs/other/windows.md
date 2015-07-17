There are a few caveats when using Drupal VM on Windows, and this page will try to identify the main gotchas or optimization tips for those wishing to use Drupal VM on a Windows host.

## Synced Folders

Most issues have to do synced folders. These are the most common ones:

### Symbolic Links

Creating symbolic links in a shared folder will fail with a permission or protocol error.

There are two parts to this:

  1. VirtualBox does not allow gets VMs to create symlinks in synced folders by default.
  2. Windows does not allow the creation of symlinks unless your local policy allows it; see [TechNet article](https://technet.microsoft.com/en-us/library/dn221947%28v=ws.10%29.aspx). Even if local policy allows it, many users experience problems in the creation of symlinks.

### GIT & Permissions

Do not work with git inside the synced folder inside the VM. Always use git on the Windows side. Otherwise the difference in permissions systems will make git think all your files have always been modified. It will also set the wrong permissions on any file you commit from inside the VM.

### Long Paths

Creating long paths inside a shared folder will fail if the length exceeds 260 characters. This usually happens when using npm. This should be solved in Vagrant 1.7.3, but if you're running an older version, you can manually make the changes here: https://github.com/mitchellh/vagrant/pull/5495/files

### NFS

You can use the [vagrant-winnfsd](https://github.com/GM-Alex/vagrant-winnfsd) plugin to get NFS support on windows. Be aware that there are multiple issues logged against both the plugin and the winnfsd project, so no guarantees.

### "Authentication failure" on vagrant up

Some Windows users have reported running into an issue where an authentication failure is reported once the VM is booted (e.g. `drupalvm: Warning: Authentication failure. Retrying...` — see [#170](https://github.com/geerlingguy/drupal-vm/issues/170)). To fix this, do the following:

  1. Delete `~/.vagrant.d/insecure_private_key`
  2. Run `vagrant ssh-config`
  3. Restart the VM with `vagrant reload`
