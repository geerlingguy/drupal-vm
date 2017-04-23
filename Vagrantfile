# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = '2' unless defined? VAGRANTFILE_API_VERSION

require './lib/drupalvm/vagrant'

# Absolute paths on the host machine.
host_drupalvm_dir = File.dirname(File.expand_path(__FILE__))
host_project_dir = ENV['DRUPALVM_PROJECT_ROOT'] || host_drupalvm_dir
host_config_dir = ENV['DRUPALVM_CONFIG_DIR'] ? "#{host_project_dir}/#{ENV['DRUPALVM_CONFIG_DIR']}" : host_project_dir

# Absolute paths on the guest machine.
guest_project_dir = '/vagrant'
guest_drupalvm_dir = ENV['DRUPALVM_DIR'] ? "/vagrant/#{ENV['DRUPALVM_DIR']}" : guest_project_dir
guest_config_dir = ENV['DRUPALVM_CONFIG_DIR'] ? "/vagrant/#{ENV['DRUPALVM_CONFIG_DIR']}" : guest_project_dir

drupalvm_env = ENV['DRUPALVM_ENV'] || 'vagrant'

vconfig = load_config([
  "#{host_drupalvm_dir}/default.config.yml",
  "#{host_config_dir}/config.yml",
  "#{host_config_dir}/local.config.yml",
  "#{host_config_dir}/#{drupalvm_env}.config.yml",
])

provisioner = vconfig['force_ansible_local'] ? :ansible_local : get_provisioner
if provisioner == :ansible
  playbook = "#{host_drupalvm_dir}/provisioning/playbook.yml"
  config_dir = host_config_dir
else
  playbook = "#{guest_drupalvm_dir}/provisioning/playbook.yml"
  config_dir = guest_config_dir
end

# Verify version requirements.
require_ansible_version ">= #{vconfig['drupalvm_ansible_version_min']}"
Vagrant.require_version ">= #{vconfig['drupalvm_vagrant_version_min']}"

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

  # Display an introduction message after `vagrant up` and `vagrant provision`.
  config.vm.post_up_message = vconfig.fetch('vagrant_post_up_message', get_default_post_up_message(vconfig))

  # If a hostsfile manager plugin is installed, add all server names as aliases.
  aliases = get_vhost_aliases(vconfig) - [config.vm.hostname]
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
      type: synced_folder.include?('type') ? synced_folder['type'] : vconfig['vagrant_synced_folder_default_type'],
      rsync__auto: 'true',
      rsync__exclude: synced_folder['excluded_paths'],
      rsync__args: ['--verbose', '--archive', '--delete', '-z', '--chmod=ugo=rwX'],
      id: synced_folder['id'],
      create: synced_folder.include?('create') ? synced_folder['create'] : false,
      mount_options: synced_folder.include?('mount_options') ? synced_folder['mount_options'] : []
    }
    if synced_folder.include?('options_override')
      synced_folder['options_override'].each do |key, value|
        options[key.to_sym] = value
      end
    end
    config.vm.synced_folder synced_folder['local_path'], synced_folder['destination'], options
  end

  # Allow override of the default synced folder type.
  config.vm.synced_folder host_project_dir, '/vagrant', type: vconfig['vagrant_synced_folder_default_type']

  config.vm.provision provisioner do |ansible|
    ansible.playbook = playbook
    ansible.extra_vars = {
      config_dir: config_dir,
      drupalvm_env: drupalvm_env
    }
    ansible.raw_arguments = ENV['DRUPALVM_ANSIBLE_ARGS']
    ansible.tags = ENV['DRUPALVM_ANSIBLE_TAGS']
  end

  # VMware Fusion.
  config.vm.provider :vmware_fusion do |v, override|
    # HGFS kernel module currently doesn't load correctly for native shares.
    override.vm.synced_folder host_project_dir, '/vagrant', type: 'nfs'

    v.gui = vconfig['vagrant_gui']
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
    v.gui = vconfig['vagrant_gui']
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

  # Cache packages and dependencies if vagrant-cachier plugin is present.
  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.scope = :box
    config.cache.auto_detect = false
    config.cache.enable :apt
    # Cache the composer directory.
    config.cache.enable :generic, cache_dir: '/home/vagrant/.composer/cache'
    config.cache.synced_folder_opts = {
      type: vconfig['vagrant_synced_folder_default_type']
    }
  end

  # Allow an untracked Vagrantfile to modify the configurations
  [host_config_dir, host_project_dir].uniq.each do |dir|
    eval File.read "#{dir}/Vagrantfile.local" if File.exist?("#{dir}/Vagrantfile.local")
  end
end
