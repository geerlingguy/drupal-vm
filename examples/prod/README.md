# Drupal VM Production Configuration Example

This directory contains an example production configuration for Drupal VM which can be used to deploy Drupal VM to a production environment on a cloud provider like DigitalOcean, Linode, or AWS.

This README file contains instructions for how you can use this configuration file to build a Drupal environment on DigitalOcean.

## Creating a DigitalOcean Droplet

If you don't already have a DigitalOcean account, create one (you can use geerlingguy's [affiliate link](https://www.digitalocean.com/?refcode=b9c57af84643) to sign up, otherwise, visit the normal [DigitalOcean Sign Up form](https://cloud.digitalocean.com/registrations/new).

Make sure you have an SSH key you can use to connect to your DigitalOcean droplets, and if you don't already have one set up, or if you need to add your existing key to your account, follow the instructions in this guide: [How to use SSH keys with DigitalOcean Droplets](https://www.digitalocean.com/community/tutorials/how-to-use-ssh-keys-with-digitalocean-droplets).

Once you are logged into DigitalOcean and have added your SSH key, click the 'Create Droplet' button on your Droplets page. For the Droplet, choose the following options:

  - **Hostname**: Choose a hostname for your site (e.g. `example.drupalvm.com`)
  - **Size**: 1 GB / 1 CPU (currently $10/month; you can choose a higher plan if needed)
  - **Region**: Choose whatever region is geographically nearest to you and your site visitors
  - **Settings**: (Nothing here affects how Drupal VM works, choose what you'd like)
  - **Image**: Choose `Ubuntu 14.04 x64`
  - **Add SSH Keys**: Select the SSH key you added to your account earlier.

Click 'Create Droplet', and wait a minute or so while the Droplet is booted. Once it's booted, make sure you can log into it from your local computer:

    ssh root@[droplet-hostname]

(Make sure you replace `[droplet-hostname]`) with the hostname or IP address of your Droplet!)

If you get a warning like "the authenticity of the host can't be established", answer yes to the prompt and hit enter. You should now be logged into the Droplet. Log back out by typing `exit` at the prompt and hitting return.

Your DigitalOcean Droplet is booted and ready to have Drupal VM installed on it.

## Customizing `config.yml` and `inventory` for production

Just like you would with the normal `example.config.yml`, you need to copy the file to `config.yml`, then go through `prod.overrides.yml` (in this directory), and make sure to update your `config.yml`, making sure all the variables are set to match `prod.overrides.yml`.

The changes outlined in `prod.overrides.yml` disable development-environment tools (like Pimp My Log and Adminer) and add extra security hardening configuration (via the `extra_security_enabled` variable).

The only other thing you need to do is copy the inventory file `example.inventory` to `inventory` (so it is located at `prod/inventory`). By default, it reads:

    [drupalvm]
    1.2.3.4 ansible_ssh_user=root

Change the host `1.2.3.4` to either the IP address or the hostname of your DigitalOcean Droplet. Remember that if you would like to use a hostname, you need to make sure that hostname actually resolves to your Droplet's IP address, either in your domain's public DNS configuration, or via your local hosts file.

## Provisioning Drupal VM on the Droplet

Run the following command within this project's root directory (the folder containing the `Vagrantfile`):

    ansible-playbook -i examples/prod/inventory provisioning/playbook.yml --sudo

After a few minutes, your Drupal-VM-in-the-cloud Droplet should be fully configured to match your local development environment! You can visit your Droplet and access the fresh Drupal site just like you would locally (e.g. `http://example.drupalvm.com/`).

## Going Further

You may want to customize your configuration further, to make sure Drupal VM is tuned for your specific Drupal site's needs, or you may want to change things and make the server configuration more flexible, etc. For all that, the book [Ansible for DevOps](http://ansiblefordevops.com/) will give you a great introduction to using Ansible to make Drupal VM and the included Ansible configuration do exactly what you need!
