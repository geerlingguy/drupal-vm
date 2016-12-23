# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = '2' unless defined? VAGRANTFILE_API_VERSION

# Absolute paths on the host machine.
host_drupalvm_dir = File.dirname(File.expand_path(__FILE__))
host_project_dir = ENV['DRUPALVM_PROJECT_ROOT'] || host_drupalvm_dir
host_config_dir = ENV['DRUPALVM_CONFIG_DIR'] ? "#{host_project_dir}/#{ENV['DRUPALVM_CONFIG_DIR']}" : host_project_dir

# Absolute paths on the guest machine.
guest_project_dir = '/vagrant'
guest_drupalvm_dir = ENV['DRUPALVM_DIR'] ? "/vagrant/#{ENV['DRUPALVM_DIR']}" : guest_project_dir
guest_config_dir = ENV['DRUPALVM_CONFIG_DIR'] ? "/vagrant/#{ENV['DRUPALVM_CONFIG_DIR']}" : guest_project_dir

drupalvm_env = ENV['DRUPALVM_ENV'] || 'vagrant'

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

def get_ansible_version(exe)
  /^[^\s]+ (.+)$/.match(`#{exe} --version`) { |match| return match[1] }
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

require 'yaml'
# Load default VM configurations.
vconfig = YAML.load_file("#{host_drupalvm_dir}/default.config.yml")
# Use optional config.yml and local.config.yml for configuration overrides.
['config.yml', 'local.config.yml', "#{drupalvm_env}.config.yml"].each do |config_file|
  if File.exist?("#{host_config_dir}/#{config_file}")
    vconfig.merge!(YAML.load_file("#{host_config_dir}/#{config_file}"))
  end
end

# Replace jinja variables in config.
vconfig = walk(vconfig) do |value|
  while value.is_a?(String) && value.match(/{{ .* }}/)
    value = value.gsub(/{{ (.*?) }}/) { vconfig[Regexp.last_match(1)] }
  end
  value
end

Vagrant.require_version ">= #{vconfig['drupalvm_vagrant_version_min']}"

ansible_bin = which('ansible-playbook')
ansible_version = Gem::Version.new(get_ansible_version(ansible_bin)) if ansible_bin
ansible_version_min = Gem::Version.new(vconfig['drupalvm_ansible_version_min'])

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
  # Remove wildcard subdomains.
  aliases.delete_if { |vhost| vhost.include?('*') }

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
  config.vm.synced_folder host_project_dir, '/vagrant', type: vconfig.include?('vagrant_synced_folder_default_type') ? vconfig['vagrant_synced_folder_default_type'] : 'nfs'

  # Provisioning. Use ansible if it's installed, ansible_local if not or if forced.
  if ansible_bin && !vconfig['force_ansible_local']
    if ansible_version < ansible_version_min
      raise "You must update Ansible to at least #{ansible_version_min} to use this version of Drupal VM."
    end
    config.vm.provision 'ansible' do |ansible|
      ansible.playbook = "#{host_drupalvm_dir}/provisioning/playbook.yml"
      ansible.extra_vars = {
        config_dir: host_config_dir,
        drupalvm_env: drupalvm_env
      }
      ansible.raw_arguments = ENV['DRUPALVM_ANSIBLE_ARGS']
    end
  else
    config.vm.provision 'ansible_local' do |ansible|
      ansible.playbook = "#{guest_drupalvm_dir}/provisioning/playbook.yml"
      ansible.extra_vars = {
        config_dir: guest_config_dir,
        drupalvm_env: drupalvm_env
      }
      ansible.raw_arguments = ENV['DRUPALVM_ANSIBLE_ARGS']
    end
  end

  # VMware Fusion.
  config.vm.provider :vmware_fusion do |v, override|
    # HGFS kernel module currently doesn't load correctly for native shares.
    override.vm.synced_folder host_project_dir, '/vagrant', type: 'nfs'

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

  # Cache packages and dependencies if vagrant-cachier plugin is present.
  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.scope = :box
    config.cache.auto_detect = false
    config.cache.enable :apt
    # Cache the composer directory.
    config.cache.enable :generic, cache_dir: '/home/vagrant/.composer/cache'
    config.cache.synced_folder_opts = {
      type: vconfig.include?('vagrant_synced_folder_default_type') ? vconfig['vagrant_synced_folder_default_type'] : 'nfs'
    }
  end

  # Allow an untracked Vagrantfile to modify the configurations
  eval File.read "#{host_config_dir}/Vagrantfile.local" if File.exist?("#{host_config_dir}/Vagrantfile.local")
end
