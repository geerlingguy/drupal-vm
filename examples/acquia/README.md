# Acquia Cloud Drupal VM Configuration Example

This directory contains example configuration changes for the default Drupal VM `example.config.yml` file which emulate the default Acquia Cloud environment with Drupal VM:

  - Ubuntu 12.04.5 LTS
  - Apache 2.2.22
  - PHP 5.5.23
  - MySQL/Percona 5.5.24
  - Apache Solr 4.5.1

To use these overrides, copy `example.config.yml` to `config.yml` as you would normally, but make sure the variables defined in `acquia.overrides.yml` are defined with the same values in your `config.yml` file.
