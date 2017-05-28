#!/bin/bash
#
# Example shell script to set up PAReview.sh.
#
# You also need to adjust your `config.yml` to add in some other dependencies.
#
#     ```
#     post_provision_scripts:
#       - "../examples/scripts/pareview.sh"
#    
#     composer_global_packages:
#       - { name: hirak/prestissimo, release: '^0.3' }
#       - { name: drupal/coder, release: '^' }
#    
#     nodejs_version: "6.x"
#     nodejs_npm_global_packages:
#       - eslint
#     ```
#
# After running `vagrant provision`, `pareview.sh` should be available anywhere
# in your Vagrant user's $PATH, so you can run commands like:
#
#     $ pareview.sh /path/to/my/module
#     $ pareview.sh http://git.drupal.org/project/rules.git 8.x-1.x
#
# See: https://github.com/klausi/pareviewsh

PAREVIEW_SETUP_COMPLETE_FILE="/etc/drupal_vm_pareview_config_complete"
HOME_PATH="/home/vagrant"

# Check to see if we've already performed this setup.
if [ ! -e "$PAREVIEW_SETUP_COMPLETE_FILE" ]; then
  # Register the `Drupal` and `DrupalPractice` Standard with PHPCS.
  $HOME_PATH/.composer/vendor/bin/phpcs --config-set installed_paths $HOME_PATH/.composer/vendor/drupal/coder/coder_sniffer

  # Download DrupalSecure.
  git clone --branch master https://git.drupal.org/sandbox/coltrane/1921926.git /opt/drupalsecure_code_sniffs

  # Move the DrupalSecure directory into the PHPCS Standards.
  sudo ln -sv /opt/drupalsecure_code_sniffs/DrupalSecure $HOME_PATH/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards

  # Install Codespell.
  sudo apt-get install -y python-pip
  pip install codespell

  # Install PAReview script.
  sudo wget -O /opt/pareview.sh https://raw.githubusercontent.com/klausi/pareviewsh/7.x-1.x/pareview.sh
  sudo chmod +x /opt/pareview.sh
  sudo ln -s /opt/pareview.sh /usr/local/bin

  # Create a file to indicate this script has already run.
  sudo touch $PAREVIEW_SETUP_COMPLETE_FILE
else
  exit 0
fi
