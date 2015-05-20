# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

# Use config.yml for basic VM configuration.
require 'yaml'
if !File.exist?('./config.yml')
  raise 'Configuration file not found! Please copy example.config.yml to config.yml and try again.'
end
vconfig = YAML::load_file("./config.yml")

# Use rbconfig to determine if we're on a windows host or not.
require 'rbconfig'
is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = vconfig['vagrant_hostname']
  config.vm.network :private_network, ip: vconfig['vagrant_ip']
  config.ssh.insert_key = false

  vconfig['vagrant_os'] ||= "ubuntu14"
  config.vm.box = case vconfig['vagrant_os']
    when "centos6" then "geerlingguy/centos6"
    when "centos7" then "geerlingguy/centos7"
    when "ubuntu12" then "geerlingguy/ubuntu1204"
    when "ubuntu14" then "geerlingguy/ubuntu1404"
    else raise 'Invalid value for vagrant_os in config.yml.'
  end

  # If hostsupdater plugin is installed, add all servernames as aliases.
  if Vagrant.has_plugin?("vagrant-hostsupdater")
    config.hostsupdater.aliases = []
    for host in vconfig['apache_vhosts']
      # Add all the hosts that aren't defined as Ansible vars.
      unless host['servername'].include? "{{"
        config.hostsupdater.aliases.push(host['servername'])
      end
    end
  end

  for synced_folder in vconfig['vagrant_synced_folders'];
    config.vm.synced_folder synced_folder['local_path'], synced_folder['destination'],
      type: synced_folder['type'],
      rsync__auto: "true",
      rsync__exclude: synced_folder['excluded_paths'],
      rsync__args: ["--verbose", "--archive", "--delete", "-z", "--chmod=ugo=rwX"],
      id: synced_folder['id'],
      create: synced_folder.include?('create') ? synced_folder['create'] : false
  end

  if is_windows
    # Provisioning configuration for shell script (for Windows).
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

  # VMware Fusion.
  config.vm.provider :vmware_fusion do |v, override|
    # HGFS kernel module currently doesn't load correctly for native shares.
    override.vm.synced_folder ".", "/vagrant", type: 'nfs'

    v.gui = false
    v.vmx["memsize"] = vconfig['vagrant_memory']
    v.vmx["numvcpus"] = vconfig['vagrant_cpus']
  end

  # VirtualBox.
  config.vm.provider :virtualbox do |v|
    v.name = vconfig['vagrant_hostname']
    v.memory = vconfig['vagrant_memory']
    v.cpus = vconfig['vagrant_cpus']
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  # Parallels.
  config.vm.provider :parallels do |p, override|
    override.vm.box = case vconfig['vagrant_os']
      when "centos6" then "parallels/centos-6.6"
      when "centos7" then "parallels/centos-7.0"
      when "ubuntu12" then "parallels/ubuntu-12.04"
      when "ubuntu14" then "parallels/ubuntu-14.04"
      else raise 'Invalid value for vagrant_os in config.yml.'
    end
    p.name = vconfig['vagrant_hostname']
    p.memory = vconfig['vagrant_memory']
    p.cpus = vconfig['vagrant_cpus']
  end

  # Set the name of the VM. See: http://stackoverflow.com/a/17864388/100134
  config.vm.define :drupaldev do |drupaldev_config|
  end
end
