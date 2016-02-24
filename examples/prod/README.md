# Drupal VM Production Configuration Example

> **Important**: This feature is currently in 'experimental' status, and the security of your servers is _your_ responsibility.

This directory contains an example production configuration for Drupal VM which can be used to deploy Drupal VM to a production environment on a cloud provider like DigitalOcean, Linode, or AWS.

This README file contains instructions for how you can use this configuration file to build a Drupal environment with Drupal VM on DigitalOcean.

## Create a DigitalOcean Droplet

If you don't already have a DigitalOcean account, create one (you can use geerlingguy's [affiliate link](https://www.digitalocean.com/?refcode=b9c57af84643) to sign up, otherwise, visit the normal [DigitalOcean Sign Up form](https://cloud.digitalocean.com/registrations/new).

Make sure you have an SSH key you can use to connect to your DigitalOcean droplets, and if you don't already have one set up, or if you need to add your existing key to your account, follow the instructions in this guide: [How to use SSH keys with DigitalOcean Droplets](https://www.digitalocean.com/community/tutorials/how-to-use-ssh-keys-with-digitalocean-droplets).

Once you are logged into DigitalOcean and have added your SSH key, click the 'Create Droplet' button on your Droplets page. For the Droplet, choose the following options:

  - **Image**: Choose `Ubuntu 14.04.x x64`
  - **Size**: 1 GB / 1 CPU (currently $10/month; you can choose a higher plan if needed)
  - **Region**: Choose whatever region is geographically nearest to you and your site visitors
  - **Settings**: (Nothing here affects how Drupal VM works, choose what you'd like)
  - **Add SSH Keys**: Select the SSH key you added to your account earlier.
  - **Hostname**: Choose a hostname for your site (e.g. `example.drupalvm.com`)

Click 'Create Droplet', and wait a minute or so while the Droplet is booted. Once it's booted, make sure you can log into it from your local computer:

    ssh root@[droplet-hostname-or-ip]

(Make sure you replace `[droplet-hostname-or-ip]`) with the hostname or IP address of your Droplet!)

If you get a warning like "the authenticity of the host can't be established", answer yes to the prompt and hit enter. You should now be logged into the Droplet. Log back out by typing `exit` at the prompt and hitting return.

Your DigitalOcean Droplet is booted and ready to have Drupal VM installed on it.

## Customize `config.yml` and `inventory` for production

Just like you would with the normal `example.config.yml`, you need to copy the file to `config.yml`, then go through `prod.overrides.yml` (in this directory), and make sure to update your `config.yml`, making sure all the variables are set to match `prod.overrides.yml`.

The changes outlined in `prod.overrides.yml` disable development-environment tools (like Pimp My Log and Adminer) and add extra security hardening configuration (via the `extra_security_enabled` variable).

The only other thing you need to do is copy the inventory file `example.inventory` to `inventory` (so it is located at `prod/inventory`). By default, it reads:

    [drupalvm]
    1.2.3.4 ansible_ssh_user=my_admin_username

Change the host `1.2.3.4` to either the IP address or the hostname of your DigitalOcean Droplet. Remember that if you would like to use a hostname, you need to make sure the hostname actually resolves to your Droplet's IP address, either in your domain's public DNS configuration, or via your local hosts file.

## Initialize the server with an administrative account

> Note: This guide assumes you have Ansible [installed](http://docs.ansible.com/ansible/intro_installation.html) on your host machine.

The first step in setting up Drupal VM on the cloud server is to initialize the server with an administrative account (which is separate from the `root` user account for better security).

Inside the `examples/prod/bootstrap` folder, copy the `example.vars.yml` file to `vars.yml` and update the variables in that file for your own administrative account (make sure especially to update the `admin_password` value!).

Then, run the following command within Drupal VM's root directory (the folder containing the `Vagrantfile`):

    ansible-playbook -i examples/prod/inventory examples/prod/bootstrap/init.yml -e "ansible_ssh_user=root"

Once the initialization is complete, you can test your new admin login with `ssh my_admin_username@droplet-hostname-or-ip`. You should be logged in via your existing SSH key. Log back out with `exit`.

## Provision Drupal VM on the Droplet

Run the following command within Drupal VM's root directory (the folder containing the `Vagrantfile`):

    ansible-playbook -i examples/prod/inventory provisioning/playbook.yml --sudo --ask-sudo-pass

Ansible will prompt you for your admin account's `sudo` password (the same as the password you encrypted and saved as `admin_password`). Enter it and press return.

After a few minutes, your Drupal-VM-in-the-cloud Droplet should be fully configured to match your local development environment! You can visit your Droplet and access the fresh Drupal site just like you would locally (e.g. `http://example.drupalvm.com/`).

## Known issues

  - You may need to manually create the `drupal_core_path` directory on the server at this time; it's not always created automatically due to permissions errors.
  - The `files` folder that is generated during the initial Drupal installation is set to be owned by the admin account; to make it work (and to allow Drupal to generate stylesheets and files correctly), you have to manually log into the server and run the following two commands after provisioning is complete:

      ```
      $ sudo chown -R www-data /var/www/drupalvm/drupal/sites/default/files
      $ sudo chmod -R 0700 /var/www/drupalvm/drupal/sites/default/files
      ```

  - You can't synchronize folders between your host machine and DigitalOcean (at least not in any sane way); so you'll need to either have Drupal VM install a site from a given Drush make file or composer.json, or deploy your site yourself.
  - The way you build a production Drupal VM instance (vs. a local instance) is a little bit of a kludge. Follow https://github.com/geerlingguy/drupal-vm/issues/455 to track progress on a more streamlined process.
  - Drupal VM doesn't include any kind of backup system. You should use one if you have any kind of important data on your server!

## Go Further

You can use Ubuntu 12.04, Ubuntu 14.04, CentOS 6 or CentOS 7 when you build the DigitalOcean Droplet. Just like with Drupal VM running locally, you can customize almost every aspect of the server!

You may want to customize your configuration even further, to make sure Drupal VM is tuned for your specific Drupal site's needs, or you may want to change things and make the server configuration more flexible, etc. For all that, the book [Ansible for DevOps](http://ansiblefordevops.com/) will give you a great introduction to using Ansible to make Drupal VM and the included Ansible configuration do exactly what you need!
