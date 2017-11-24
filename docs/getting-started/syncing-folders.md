You can share folders between your host computer and the VM in a variety of ways; the most commonly-used method is an NFS share. If you use Windows and encounter any problems with NFS, try switching to `smb`. The `default.config.yml` file contains an example `nfs` share that would sync the entire drupal-vm directory (configured as the relative path `.`) on your host into the `/var/www/drupalvm` folder on Virtual Machine.

If you want to use a different synced folder method (e.g. `smb`), you can change `type`:

```yaml
vagrant_synced_folders:
  - local_path: .
    destination: /var/www/drupalvm
    type: smb
    create: true
```

You can add as many synced folders as you'd like, and you can configure [any type of share](https://www.vagrantup.com/docs/synced-folders/index.html) supported by Vagrant; just add another item to the list of `vagrant_synced_folders`.

## Options

The synced folder options exposed are `type`, `excluded_paths` (when using rsync), `id`, `create`, `mount_options` and `nfs_udp`. Besides these there are some sane defaults set when using rsync. For example all files synced with rsync will be writable by everyone, thus allowing the web server to create files.

### Overriding defaults

If you feel the need to fine-tune some of the options not exposed, the entire options hash passed to Vagrant can be overriden using `options_override`.

The merge of the default options and `options_override` is shallow, so you can use it to remove flags from eg. `rsync__args`.

One scenario where this might be useful is when you are moving generated code from the virtual machine back to your local machine and you want the files to have appropriate permissions instead of the default 666/777.

```yaml
options_override:
  owner: vagrant
  group: www-data
  rsync__args: [
    "--verbose", "--archive", "--delete",
    "--chmod=gu=rwX,o=rX", # 664 for files, 775 for directories
  ]
```

## Synced Folder Troubleshooting

_Read the following [overview on the performance of the different synced folder mechanisms](../other/performance.md#synced-folder-performance)._


There are a number of issues people encounter with synced folders from time to time. The most frequent issues are listed below with possible solutions:

### Using Native Synced Folders

You can use a native synced folder, which should work pretty flawlessly on any platform, but with a potential serious performance downside (compared to other synced folder methods). Just set `type` to `""`.

```yaml
vagrant_synced_folders:
  - local_path: .
    destination: /var/www/docroot
    type: ""
    create: true
```

See [this issue](https://github.com/geerlingguy/drupal-vm/issues/67) for more information.

### Permissions-related errors

If you're encountering errors where Drupal or some other software inside the VM is having permissions issues creating or deleting files inside a synced folder, you might need to either make sure the file permissions are correct on your host machine (if a folder is not readable by you, it probably also won't be readable when mounted via NFS!), or add extra configuration to the synced folders item (if using a sync method like `rsync`):

```yaml
vagrant_synced_folders:
  - local_path: .
    destination: /var/www/drupalvm
    type: ""
    create: true
    mount_options: ["dmode=775", "fmode=664"]
    options_override:
      owner: "vagrant"
      group: "www-data"
```

See [this issue](https://github.com/geerlingguy/drupal-vm/issues/66) for more details.

### Using [`vagrant-bindfs`](https://github.com/gael-ian/vagrant-bindfs) to work around permissions-related errors

If you're using NFS synced folders the mounted directories will use the same numeric permissions on the guest VM as on the host OS. If you're on OSX for instance, your files within the VM would be owned by 501:20. To correct these permissions you can use the [`vagrant-bindfs` plugin](https://github.com/gael-ian/vagrant-bindfs) to mount your NFS folders to a temporary location and then re-mount them to the actual destination with the correct ownership.

First install the plugin with `vagrant plugin install vagrant-bindfs` and then add a `Vagrantfile.local` with the following:

```rb
vconfig['vagrant_synced_folders'].each do |synced_folder|
  case synced_folder['type']
  when "nfs"
    guest_path = synced_folder['destination']
    host_path = File.expand_path(synced_folder['local_path'])
    config.vm.synced_folders[guest_path][:guestpath] = "/var/nfs#{host_path}"
    config.bindfs.bind_folder "/var/nfs#{host_path}", guest_path,
      u: 'vagrant',
      g: 'www-data',
      perms: 'u=rwX:g=rwD',
      o: 'nonempty'
    config.nfs.map_uid = Process.uid
    config.nfs.map_gid = Process.gid
  end
end
```

### Other NFS-related errors

If you're having other weird issues, and none of the above fixes helps, you might want to try a different synced folder method (see top of this page), or something like File Conveyor or a special rsync setup (see [here](http://wolfgangziegler.net/auto-rsync-local-changes-to-remote-server#comments) for some examples).
