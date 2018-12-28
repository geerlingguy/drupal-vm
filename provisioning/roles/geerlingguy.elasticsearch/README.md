# Ansible Role: Elasticsearch

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-elasticsearch.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-elasticsearch)

An Ansible Role that installs Elasticsearch on RedHat/CentOS or Debian/Ubuntu.

## Requirements

Requires at least Java 8. See [`geerlingguy.java`](https://github.com/geerlingguy/ansible-role-java#example-playbook-install-openjdk-8) role instructions for installing OpenJDK 8.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    elasticsearch_version: '6.x'

The major version to use when installing Elasticsearch.

    elasticsearch_package_state: present

The `elasticsearch` package state; set to `latest` to upgrade or change versions.

    elasticsearch_service_state: started
    elasticsearch_service_enabled: true

Controls the Elasticsearch service options.

    elasticsearch_network_host: localhost

Network host to listen for incoming connections on. By default we only listen on the localhost interface. Change this to the IP address to listen on a specific interface, or `0.0.0.0` to listen on all interfaces.

    elasticsearch_http_port: 9200

The port to listen for HTTP connections on.

## Dependencies

  - geerlingguy.java

## Example Playbook

    - hosts: search
      roles:
        - geerlingguy.java
        - geerlingguy.elasticsearch

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
