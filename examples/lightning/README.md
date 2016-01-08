# Setting up Drupal 8 - Lightning Distribution 

This directory contains example configuration changes for the default Drupal VM `example.config.yml` in order to 
setup the Drupal 8 installation with the [Lightning Distribution](http://lightning.website/). 

The configuration uses Nginx and sets up some convenient hostname mappings so that there is no need to modify the 
`/etc/hosts` file before access the VM.

1) The latest Lightning distribution should be downloaded from the latest 
[Release Page](https://www.drupal.org/node/2105097/release?api_version%5B%5D=7234).  As of now, the latest release is 
`lightning-8.x-1.0-beta1-core.tar.gz` but go ahead and download the latest stable if available.

2) Unzip the downloaded file into a working directory (e.g ~/LIGHTNING) which will be later configured to be synced into
the VM.  In this example, the full path will be `~/LIGHTNING/lightning-8.x-1.0-beta1`.

3) Modify the configuration file using the example overrides.

To use these overrides, copy `example.config.yml` to `config.yml` as you would normally, but make sure the variables 
defined in `lightning.overrides.yml` are defined with the same values in your `config.yml` file.

4) Start up the VM with `vagrant up`.

5) Access the site and ensure the VM has been properly setup:

  - [Drupal 8 w/ Lightning Distribution](http://drupal.192.168.88.88.xip.io)
  - [Adminer for GUI DB Access](http://adminer.192.168.88.88.xip.io)
  - [MailHog for Monitoring Mail Delivery](http://drupal.192.168.88.88.xip.io:8025)
  - [PimpMyLog for Monitoring Logs](http://pimpmylog.192.168.88.88.xip.io)

Find example in [Lightning Example Config](lightning.overrides.yml)