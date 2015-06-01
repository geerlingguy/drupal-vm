# JJG-Ansible-Windows

Windows shell provisioning script to bootstrap Ansible from within a Vagrant VM running on Windows.

This script is configured to use configure any Linux-based VM (Debian, Ubuntu, Fedora, RedHat, CentOS, etc.) so it can run Ansible playbooks from within the VM through Vagrant.

Read more about this script, and other techniques for using Ansible within a Windows environment, on Server Check.in: [Running Ansible within Windows](https://servercheck.in/blog/running-ansible-within-windows).

## Usage

In your Vagrantfile, use a conditional provisioning statement if you want to use this script (which runs Ansible from within the VM instead of on your host—this example assumes your playbook is inside within a 'provisioning' folder, and this script is within provisioning/JJG-Ansible-Windows):

```ruby
# Use rbconfig to determine if we're on a windows host or not.
require 'rbconfig'
is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
if is_windows
  # Provisioning configuration for shell script.
  config.vm.provision "shell" do |sh|
    sh.path = "provisioning/JJG-Ansible-Windows/windows.sh"
    sh.args = "provisioning/playbook.yml"
  end
else
  # Provisioning configuration for Ansible (for Mac/Linux hosts).
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provisioning/playbook.yml"
    ansible.sudo = true
  end
end
```

Note that the `windows.sh` script will run within the VM and will run the given playbook against localhost with `--connection=local` inside the VM. You shouldn't/can't pass a custom inventory file to the script, as you can using Vagrant's Ansible provisioner.

### Role Requirements File

If your playbook requires roles to be installed which are not present in a `roles` directory within the playbook's directory, then you should add the roles to a [role requirements](http://docs.ansible.com/galaxy.html#advanced-control-over-role-requirements-files) file. Place the resulting `requirements.txt` or `requirements.yml` file in the same directory as your playbook, and the roles will be installed automatically.

## Licensing and More Info

Created by [Jeff Geerling](http://jeffgeerling.com/) in 2014. Licensed under the MIT license; see the LICENSE file for more info.
