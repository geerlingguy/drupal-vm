# HOWTO Setup Drupal Distributions

Drupal VM is compatible with various Drupal Distributions, enabling the quick setup of nicely curated setups.

The criteria would be that the Distribution should support installation via 
[Drush Make Deployment](../deployment/drush-make.md).

Steps to Use Distributions with Drupal VM:

    1. Download the distribution.
    2. Identify the relevant drush-make build file.  For example, the Lightning Distribution drush-make build 
       file is called `build-lightning.make.yml`.
    3. Modify the `config.yml` to point to the drush-make file and use the correct profile value. 

Learn more about setting up Drupal VM to use the latest Drupal 8 Lightning Distribution
[here](../../examples/lightning/README.md)