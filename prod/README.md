# Deploy Drupal VM to the Cloud

This directory contains an example production configuration for Drupal VM which can be used to deploy Drupal VM to a production environment on a cloud provider like DigitalOcean, Linode, or AWS.

This README file contains instructions for how you can use this configuration file to build a Drupal environment on DigitalOcean.

## Creating a DigitalOcean Droplet

If you don't already have a DigitalOcean account, create one.

TODO: Add SSH key to your account...

Click the 'Create Droplet' button on your Droplets page. For the Droplet, choose the following options:

  - **Hostname**: Choose a hostname for your site (e.g. `example.drupalvm.com`)
  - **Size**: 1 GB / 1 CPU (currently $10/month)
  - **Region**: Choose whatever region is geographically nearest to you and your site visitors
  - **Settings**: (Nothing here affects how Drupal VM works, choose what you'd like)
  - **Image**: Choose `Ubuntu 14.04 x64`
  - **Add SSH Keys**: Select the SSH key you added to your account earlier.

Click 'Create Droplet', and wait a minute or so while the Droplet is booted. Once it's booted, make sure you can log into it from your local computer:

    ssh root@example.drupalvm.com

If you get a warning like "the authenticity of the host can't be established", answer yes to the prompt and hit enter. You should now be logged into the Droplet. Log back out by typing `exit` at the prompt and hitting return.

Your DigitalOcean Droplet is booted and ready to have Drupal VM installed on it.

## Customizing `example-prod.config.yml` and `inventory` for production

Just like you would with the normal `example.config.yml`, you need to customize `example-prod.config.yml` for your site, and move the configuration file into the root directory of the project (in the same directory as the Vagrantfile).

The main differences between the prod example `config.yml` and the normal example is that all development-environment tools (like Pimp My Log and Adminer) are _not_ installed, and some extra security hardening configuration is added (via the `extra_security_enabled` variable).

The only other thing you need to change, after copying and configuring `example-prod.config.yml`, is the inventory file at `prod/inventory`. By default, it reads:

    [drupalvm]
    1.2.3.4 ansible_ssh_user=root

Change the host `1.2.3.4` to either the IP address or the hostname of your DigitalOcean Droplet. Remember that if you would like to use a hostname, you need to make sure that hostname actually resolves to your Droplet's IP address, either in your domain's public DNS configuration, or via your local hosts file.

## Provisioning Drupal VM on the Droplet

Run the following command within this project's root directory (the folder containing the `Vagrantfile`):

    ansible-playbook -i prod/inventory provisioning/playbook.yml --sudo

After a few minutes, your Drupal-VM-in-the-cloud Droplet should be fully configured to match your local development environment! You can visit your Droplet and access the fresh Drupal site just like you would locally (e.g. `http://example.drupalvm.com/`).

## Going Further

TODO - Mention book, mention making the configuration more flexible, etc.
