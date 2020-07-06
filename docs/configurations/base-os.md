Drupal VM's configuration is designed to work with RedHat and Debian-compatible operating systems. Therefore, if you switch the `vagrant_box` in `config.yml` to any compatible OS, Drupal VM and all it's configuration should _Just Work™_... but that's not always the case.

Currently-supported OSes are:

  - Ubuntu 18.04 'Bionic' (default)
  - RedHat Enterprise Linux / CentOS 8
  - Debian 10 'Buster'

For certain OSes, there are a couple other caveats and tweaks you may need to perform to get things running smoothly—the main features and latest development is only guaranteed to work with the default OS as configured in `default.config.yml`.

Some other OSes may work, but are not regularly tested with Drupal VM, and may require extra work to make everything work, depending on the version of Drupal you're using.

## Ubuntu 18.04 Bionic LTS

Everything should work out of the box with Ubuntu 18.04.

## RedHat Enterprise Linux / CentOS 8

Everything should work out of the box with RHEL 8.

## Debian 10 Buster

Most everything should work out of the box with Debian 10. If you are installing `java` or `solr` in the `installed_extras`, you need to override the `java_packages` in your `config.yml`:

    java_packages:
      - openjdk-11-jdk
