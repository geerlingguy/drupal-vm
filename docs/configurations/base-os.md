Drupal VM's configuration is designed to work with RedHat and Debian-compatible operating systems. Therefore, if you switch the `vagrant_box` in `config.yml` to any compatible OS, Drupal VM and all it's configuration should _Just Work™_... but that's not always the case.

Currently-supported OSes are:

  - Ubuntu 18.04 'Bionic' (default)
  - Ubuntu 16.04 'Xenial'
  - RedHat Enterprise Linux / CentOS 8
  - RedHat Enterprise Linux / CentOS 7
  - Debian 10 'Buster'
  - Debian 9 'Stretch'

For certain OSes, there are a couple other caveats and tweaks you may need to perform to get things running smoothly—the main features and latest development is only guaranteed to work with the default OS as configured in `default.config.yml`.

Some other OSes should work, but are not regularly tested with Drupal VM, including Debian 8/Jessie (`debian/jessie64`).

## Ubuntu 18.04 Bionic LTS

Everything should work out of the box with Ubuntu 18.04.

## Ubuntu 16.04 Xenial LTS

Most everything should work out of the box with Ubuntu 16.04. You will need to override one variable in your `config.yml` to use an older version of Python when provisioning:

    ansible_python_interpreter: /usr/bin/python

## RedHat Enterprise Linux / CentOS 8

Everything should work out of the box with RHEL 8.

## RedHat Enterprise Linux / CentOS 7

Most everything should work out of the box with CentOS 7. You will need to override one variable in your `config.yml` to use an older version of Python when provisioning:

    ansible_python_interpreter: /usr/bin/python

## Debian 10 Buster

Most everything should work out of the box with Debian 10. If you are installing `java` or `solr` in the `installed_extras`, you need to override the `java_packages` in your `config.yml`:

    java_packages:
      - openjdk-11-jdk

## Debian 9 Stretch

Everything should work out of the box with Debian 10.
