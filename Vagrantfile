# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = '2'

# Cross-platform way of finding an executable in the $PATH.
def which(cmd)
  exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    exts.each do |ext|
      exe = File.join(path, "#{cmd}#{ext}")
      return exe if File.executable?(exe) && !File.directory?(exe)
    end
  end
  nil
end

def walk(obj, &fn)
  if obj.is_a?(Array)
    obj.map { |value| walk(value, &fn) }
  elsif obj.is_a?(Hash)
    obj.each_pair { |key, value| obj[key] = walk(value, &fn) }
  else
    obj = yield(obj)
  end
end

# Use config.yml for basic VM configuration.
require 'yaml'
dir = File.dirname(File.expand_path(__FILE__))
unless File.exist?("#{dir}/config.yml")
  raise 'Configuration file not found! Please copy example.config.yml to config.yml and try again.'
end
vconfig = YAML.load_file("#{dir}/config.yml")

# Replace jinja variables in config.
vconfig = walk(vconfig) do |value|
  while value.is_a?(String) && value.match(/{{ .* }}/)
    value = value.gsub(/{{ (.*?) }}/) { vconfig[Regexp.last_match(1)] }
  end
  value
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Networking configuration.
  config.vm.hostname = vconfig['vagrant_hostname']
  if vconfig['vagrant_ip'] == '0.0.0.0' && Vagrant.has_plugin?('vagrant-auto_network')
    config.vm.network :private_network, ip: vconfig['vagrant_ip'], auto_network: true
  else
    config.vm.network :private_network, ip: vconfig['vagrant_ip']
  end

  if !vconfig['vagrant_public_ip'].empty? && vconfig['vagrant_public_ip'] == '0.0.0.0'
    config.vm.network :public_network
  elsif !vconfig['vagrant_public_ip'].empty?
    config.vm.network :public_network, ip: vconfig['vagrant_public_ip']
  end

  # SSH options.
  config.ssh.insert_key = false
  config.ssh.forward_agent = true

  # Vagrant box.
  config.vm.box = vconfig['vagrant_box']

  # If a hostsfile manager plugin is installed, add all server names as aliases.
  aliases = []
  if vconfig['drupalvm_webserver'] == 'apache'
    vconfig['apache_vhosts'].each do |host|
      aliases.push(host['servername'])
      aliases.concat(host['serveralias'].split) if host['serveralias']
    end
  else
    vconfig['nginx_hosts'].each do |host|
      aliases.concat(host['server_name'].split)
      aliases.concat(host['server_name_redirect'].split) if host['server_name_redirect']
    end
  end
  aliases = aliases.uniq - [config.vm.hostname, vconfig['vagrant_ip']]

  if Vagrant.has_plugin?('vagrant-hostsupdater')
    config.hostsupdater.aliases = aliases
  elsif Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.aliases = aliases
  end

  # Synced folders.
  vconfig['vagrant_synced_folders'].each do |synced_folder|
    options = {
      type: synced_folder['type'],
      rsync__auto: 'true',
      rsync__exclude: synced_folder['excluded_paths'],
      rsync__args: ['--verbose', '--archive', '--delete', '-z', '--chmod=ugo=rwX'],
      id: synced_folder['id'],
      create: synced_folder.include?('create') ? synced_folder['create'] : false,
      mount_options: synced_folder.include?('mount_options') ? synced_folder['mount_options'] : []
    }
    if synced_folder.include?('options_override')
      options = options.merge(synced_folder['options_override'])
    end
    config.vm.synced_folder synced_folder['local_path'], synced_folder['destination'], options
  end

  # Allow override of the default synced folder type.
  config.vm.synced_folder '.', '/vagrant', type: vconfig.include?('vagrant_synced_folder_default_type') ? vconfig['vagrant_synced_folder_default_type'] : 'nfs'

  # Provisioning. Use ansible if it's installed, JJG-Ansible-Windows if not.
  if which('ansible-playbook')
    config.vm.provision 'ansible' do |ansible|
      ansible.playbook = "#{dir}/provisioning/playbook.yml"
    end
  else
    config.vm.provision 'shell' do |sh|
      sh.path = "#{dir}/provisioning/JJG-Ansible-Windows/windows.sh"
      sh.args = '/provisioning/playbook.yml'
    end
  end
  # ansible_local provisioner is broken in Vagrant < 1.8.2.
  # else
  #   config.vm.provision "ansible_local" do |ansible|
  #     ansible.playbook = "provisioning/playbook.yml"
  #     ansible.galaxy_role_file = "provisioning/requirements.yml"
  #   end
  # end

  # VMware Fusion.
  config.vm.provider :vmware_fusion do |v, override|
    # HGFS kernel module currently doesn't load correctly for native shares.
    override.vm.synced_folder '.', '/vagrant', type: 'nfs'

    v.gui = false
    v.vmx['memsize'] = vconfig['vagrant_memory']
    v.vmx['numvcpus'] = vconfig['vagrant_cpus']
  end

  # VirtualBox.
  config.vm.provider :virtualbox do |v|
    v.linked_clone = true if Vagrant::VERSION =~ /^1.8/
    v.name = vconfig['vagrant_hostname']
    v.memory = vconfig['vagrant_memory']
    v.cpus = vconfig['vagrant_cpus']
    v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    v.customize ['modifyvm', :id, '--ioapic', 'on']
  end

  # Parallels.
  config.vm.provider :parallels do |p, override|
    override.vm.box = vconfig['vagrant_box']
    p.name = vconfig['vagrant_hostname']
    p.memory = vconfig['vagrant_memory']
    p.cpus = vconfig['vagrant_cpus']
    p.update_guest_tools = true
  end

  # Set the name of the VM. See: http://stackoverflow.com/a/17864388/100134
  config.vm.define vconfig['vagrant_machine_name']

  # Allow an untracked Vagrantfile to modify the configurations
  eval File.read 'Vagrantfile.local' if File.exist?('Vagrantfile.local')
end
