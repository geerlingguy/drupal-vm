Please read through the [Quick Start Guide in the README](https://github.com/geerlingguy/drupal-vm#quick-start-guide) to get started.

<iframe width="560" height="315" src="https://www.youtube.com/embed/mNio_aXMLos" frameborder="0" allowfullscreen></iframe>

_In this video, Jeff Geerling walk you through getting a Drupal 8 website built on your Windows 10 laptop using Drupal VM 3._

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

## Troubleshooting Vagrant Synced Folders

Most issues have to do synced folders. These are the most common ones:

_Read the following to [improve the performance of synced folders by using NFS, samba or rsync](../other/performance.md#improving-performance-on-windows)._

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

### "Authentication failure" on vagrant up

Some Windows users have reported running into an issue where an authentication failure is reported once the VM is booted (e.g. `drupalvm: Warning: Authentication failure. Retrying...` — see [#170](https://github.com/geerlingguy/drupal-vm/issues/170)). To fix this, do the following:

  1. Delete `~/.vagrant.d/insecure_private_key`
  2. Run `vagrant ssh-config`
  3. Restart the VM with `vagrant reload`

### Windows 7 requires PowerShell upgrade

If you are running Windows 7 and `vagrant up` hangs, you may need to upgrade PowerShell. Windows 7 ships with PowerShell 2.0, but PowerShell 3.0 or higher is required. For Windows 7, you can upgrade to PowerShell 4.0 which is part of the [Windows Management Framework](http://www.microsoft.com/en-us/download/details.aspx?id=40855).

## Hosts file updates

If you install either the `vagrant-hostsupdater` (installed by default unless removed from `vagrant_plugins` in your `config.yml`) or `vagrant-hostmanager` plugin, you might get a permissions error when Vagrant tries changing the hosts file. On a macOS or Linux workstation, you're prompted for a sudo password so the change can be made, but on Windows, you have to do one of the following to make sure hostsupdater works correctly:

  1. Run PowerShell or whatever CLI you use with Vagrant as an administrator. Right click on the application and select 'Run as administrator', then proceed with `vagrant` commands as normal.
  2. Change the permissions on the hosts file so your account has permission to edit the file (this has security implications, so it's best to use option 1 unless you know what you're doing). To do this, open `%SystemRoot%\system32\drivers\etc` in Windows Explorer, right-click the `hosts` file, and under Security, add your account and give yourself full access to the file.

## Intel VT-x virtualization support

On some laptops, Intel VT-x virtualization (which is built into most modern Intel processors) is enabled by default. This allows VirtualBox to run virtual machines efficiently using the CPU itself instead of software CPU emulation. If you get a message like "VT-x is disabled in the bios for both all cpu modes" or something similar, you may need to enter your computer's BIOS settings and enable this virtualization support.
