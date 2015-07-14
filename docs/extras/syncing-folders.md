You can share folders between your host computer and the VM in a variety of ways; the most commonly-used method is an NFS share. If you use Windows and encounter any problems with NFS, try switching to `smb`. The `example.config.yml` file contains an example `nfs` share that would sync the folder `~/Sites/drupalvm` on your host into the `/var/www` folder on Drupal VM.

If you want to use a different synced folder method (e.g. `smb`), you can change `type` to:

```yaml
vagrant_synced_folders:
  - local_path: ~/Sites/drupalvm
    destination: /var/www
    id: drupal
    type: smb
```

You can add as many synced folders as you'd like, and you can configure [any type of share](https://docs.vagrantup.com/v2/synced-folders/index.html) supported by Vagrant; just add another item to the list of `vagrant_synced_folders`.

## Synced Folder Performance

Using different synced folder mechanisms can have a dramatic impact on your Drupal site's performance. Please read through the following blog posts for a thorough overview of synced folder performance:

  - [Comparing filesystem performance in Virtual Machines](http://mitchellh.com/comparing-filesystem-performance-in-virtual-machines)
  - [NFS, rsync, and shared folder performance in Vagrant VMs](http://www.midwesternmac.com/blogs/jeff-geerling/nfs-rsync-and-shared-folder)

Generally speaking:

  - NFS offers a decent tradeoff between performance and ease of use
  - SMB offers a similar tradeoff, but is a bit slower than NFS
  - Rsync offers the best performance inside the VM, but sync is currently one-way-only (from host to VM), which can make certain development workflows burdensome
  - Native shared folders offer abysmal performance; only use this mechanism as a last resort!

## Synced Folder Troubleshooting

There are a number of issues people encounter with synced folders from time to time. The most frequent issues are listed below with possible solutions:

### Using Native Synced Folders

You can use a native synced folder, which should work pretty flawlessly on any platform, but with a potential serious performance downside (compared to other synced folder methods). Just set `type` to `""`, and you can even put the synced folder inside the drupal-vm folder using a relative path, like:

```yaml
vagrant_synced_folders:
  - local_path: docroot
    destination: /var/www/docroot
    id: drupal
    type: ""
    create: true
```

See [this issue](https://github.com/geerlingguy/drupal-vm/issues/67) for more information.

### VirtualBox Guest Additions out of date

If you get errors when running `vagrant up` stating that your guest additions are out of date, you can fix this easily by installing the `vagrant-vbguest` plugin. Run the following command in the drupal-vm folder: `vagrant plugin install vagrant-vbguest`.

Otherwise, you will need to make sure you're using the officially supported `geerlingguy/ubuntu1404` box, which should _generally_ have the latest (or near-latest) guest additions installed. If not, please open an issue in the upstream project for building the base box: [`packer-ubuntu-1404`](https://github.com/geerlingguy/packer-ubuntu-1404).

### Permissions-related errors

If you're encountering errors where Drupal or some other software inside the VM is having permissions issues creating or deleting files inside a synced folder, you might need to either make sure the file permissions are correct on your host machine (if a folder is not readable by you, it probably also won't be readable when mounted via NFS!), or add extra configuration to the synced folders item inside the Vagrantfile (if using a sync method like `rsync`):

```
owner: "vagrant",
group: "www-data",
mount_options: ["dmode=775,fmode=664"]
```

See [this issue](https://github.com/geerlingguy/drupal-vm/issues/66) for more details.

### VirtualBox Symbolic Links

When using native VirtualBox shares, VirtualBox does not allow guest VMs to create symbolic links on synced folders for security reasons. On CentOS this prevents apache from installing since it will try to make a symlink inside `/var/www/` You can change the Drupal synced_folder to `/var/www/drupal` and the `drupal_core_path` to `/var/www/drupal/docroot` to work around this.

There are many other potential [solutions](https://www.google.com/search?q=SharedFoldersEnableSymlinksCreate) available on the Internet.

### Other NFS-related errors

If you're having other weird issues, and none of the above fixes helps, you might want to try a different synced folder method (see top of this page), or something like File Conveyor or a special rsync setup (see [here](http://wolfgangziegler.net/auto-rsync-local-changes-to-remote-server#comments) for some examples).