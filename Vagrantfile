# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

# Use config.yml for basic VM configuration.
require 'yaml'
dir = File.dirname(File.expand_path(__FILE__))
if !File.exist?("#{dir}/config.yml")
  raise 'Configuration file not found! Please copy example.config.yml to config.yml and try again.'
end
vconfig = YAML::load_file("#{dir}/config.yml")

# Use rbconfig to determine if we're on a windows host or not.
require 'rbconfig'
is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = vconfig['vagrant_hostname']
  if vconfig['vagrant_ip'] == "0.0.0.0" && Vagrant.has_plugin?("vagrant-auto_network")
    config.vm.network :private_network, :ip => vconfig['vagrant_ip'], :auto_network => true
  else
    config.vm.network :private_network, ip: vconfig['vagrant_ip']
  end
  config.ssh.insert_key = false
  config.ssh.forward_agent = true

  config.vm.box = vconfig['vagrant_box']

  # If hostsupdater plugin is installed, add all servernames as aliases.
  if Vagrant.has_plugin?("vagrant-hostsupdater")
    config.hostsupdater.aliases = []

    # Add in the drupal_domain if it is different from vagrant_hostname.
    if vconfig['drupal_domain'] != config.vm.hostname
      config.hostsupdater.aliases.push(vconfig['drupal_domain'])
    end

    # Add hosts for all server names and aliases that are not the same
    # as vagrant_hostname.
    for host in vconfig['apache_vhosts']
      # Vhost server name.
      servername = host['servername'].sub('{{ drupal_domain }}', vconfig['drupal_domain'])
      if servername != config.vm.hostname && !config.hostsupdater.aliases.index(servername)
        config.hostsupdater.aliases.push(servername)
      end

      # Vhost server aliases.
      # Can be a space deliminated list of host names, so we have to iterate over them.
      if host['serveralias'] && !host['serveralias'].empty?
        serveraliases = host['serveralias'].gsub('{{ drupal_domain }}', vconfig['drupal_domain'])
        server_alias_array = serveraliases.split(' ')
        for server_alias in server_alias_array
          if server_alias != config.vm.hostname && !config.hostsupdater.aliases.index(server_alias)
            config.hostsupdater.aliases.push(server_alias)
          end          
        end
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
      create: synced_folder.include?('create') ? synced_folder['create'] : false,
      mount_options: synced_folder.include?('mount_options') ? synced_folder['mount_options'] : []
  end

  if is_windows
    # Provisioning configuration for shell script (for Windows).
    config.vm.provision "shell" do |sh|
      sh.path = "#{dir}/provisioning/JJG-Ansible-Windows/windows.sh"
      sh.args = "/provisioning/playbook.yml"
    end
  else
    # Provisioning configuration for Ansible (for Mac/Linux hosts).
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "#{dir}/provisioning/playbook.yml"
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
    override.vm.box = vconfig['vagrant_box']
    p.name = vconfig['vagrant_hostname']
    p.memory = vconfig['vagrant_memory']
    p.cpus = vconfig['vagrant_cpus']
  end

  # Set the name of the VM. See: http://stackoverflow.com/a/17864388/100134
  config.vm.define vconfig['vagrant_machine_name'] do |d|
  end
end
