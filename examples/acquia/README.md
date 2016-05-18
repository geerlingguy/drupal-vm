# Acquia Cloud Drupal VM Configuration Example

This directory contains example configuration overrides for the default Drupal VM `default.config.yml` file which emulate the default Acquia Cloud environment with Drupal VM:

  - Ubuntu 12.04.5 LTS
  - Apache 2.2.22
  - PHP 5.6.21
  - MySQL/Percona 5.5.24
  - Apache Solr 4.5.1

To use these overrides, copy `acquia.config.yml` to `config.yml`, and by looking at `default.config.yml` add any other overrides you'd like. Whatever variables you have set in `config.yml` will override the defaults set by `default.config.yml`.
