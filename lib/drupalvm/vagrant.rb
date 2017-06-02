require 'yaml'

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

# Recursively walk an tree and run provided block on each value found.
def walk(obj, &fn)
  if obj.is_a?(Array)
    obj.map { |value| walk(value, &fn) }
  elsif obj.is_a?(Hash)
    obj.each_pair { |key, value| obj[key] = walk(value, &fn) }
  else
    obj = yield(obj)
  end
end

# Resolve jinja variables in hash.
def resolve_jinja_variables(vconfig)
  walk(vconfig) do |value|
    while value.is_a?(String) && value.match(/{{ .* }}/)
      value = value.gsub(/{{ (.*?) }}/) { vconfig[Regexp.last_match(1)] }
    end
    value
  end
end

# Return the combined configuration content all files provided.
def load_config(files)
  vconfig = {}
  files.each do |config_file|
    if File.exist?(config_file)
      optional_config = YAML.load_file(config_file)
      vconfig.merge!(optional_config) if optional_config
    end
  end
  resolve_jinja_variables(vconfig)
end

# Return the path to the ansible-playbook executable.
def ansible_bin
  @ansible_bin ||= which('ansible-playbook')
end

# Return the ansible version parsed from running the executable path provided.
def ansible_version
  /^[^\s]+ (.+)$/.match(`#{ansible_bin} --version`) { |match| return match[1] }
end

# Require that if installed, the ansible version meets the requirements.
def require_ansible_version(requirement)
  return unless ansible_bin
  req = Gem::Requirement.new(requirement)
  return if req.satisfied_by?(Gem::Version.new(ansible_version))
  raise_message "You must install an Ansible version #{requirement} to use this version of Drupal VM."
end

def raise_message(msg)
  raise Vagrant::Errors::VagrantError.new, msg
end

# Return which Vagrant provisioner to use.
def vagrant_provisioner
  ansible_bin ? :ansible : :ansible_local
end

def ensure_plugins(plugins)
  logger = Vagrant::UI::Colored.new
  installed = false

  plugins.each do |plugin|
    plugin_name = plugin['name']
    manager = Vagrant::Plugin::Manager.instance

    next if manager.installed_plugins.key?(plugin_name)

    logger.warn("Installing plugin #{plugin_name}")

    manager.install_plugin(
      plugin_name,
      sources: plugin.fetch('source', %w[https://rubygems.org/ https://gems.hashicorp.com/]),
      version: plugin['version']
    )

    installed = true
  end

  return unless installed

  logger.warn('`vagrant up` must be re-run now that plugins are installed')
  exit
end

def get_apache_vhosts(vhosts)
  aliases = []
  vhosts.each do |host|
    aliases.push(host['servername'])
    aliases.concat(host['serveralias'].split) if host['serveralias']
  end
  aliases
end

def get_nginx_vhosts(vhosts)
  aliases = []
  vhosts.each do |host|
    aliases.push(host['server_name'])
    aliases.concat(host['server_name_redirect'].split) if host['server_name_redirect']
  end
  aliases
end

# Return a list of all virtualhost server names and aliases from a config hash.
def get_vhost_aliases(vconfig)
  if vconfig['drupalvm_webserver'] == 'apache'
    aliases = get_apache_vhosts(vconfig['apache_vhosts'])
  else
    # @todo shim for `nginx_hosts`.
    aliases = get_nginx_vhosts(vconfig.fetch('nginx_hosts', vconfig['nginx_vhosts']))
  end
  aliases = aliases.uniq - [vconfig['vagrant_ip']]
  # Remove wildcard subdomains.
  aliases.delete_if { |vhost| vhost.include?('*') }
end

# Return a default post_up_message.
def get_default_post_up_message(vconfig)
  'Your Drupal VM Vagrant box is ready to use!'\
    "\n* Visit the dashboard for an overview of your site: http://dashboard.#{vconfig['vagrant_hostname']} (or http://#{vconfig['vagrant_ip']})"\
    "\n* You can SSH into your machine with `vagrant ssh`."\
    "\n* Find out more in the Drupal VM documentation at http://docs.drupalvm.com"
end
