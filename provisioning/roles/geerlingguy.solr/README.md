# Ansible Role: Apache Solr

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-solr.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-solr)

Installs [Apache Solr](http://lucene.apache.org/solr/) on Linux servers.

## Requirements

Java must be available on the server. You can easily install Java using the `geerlingguy.java` role. Make sure the Java version installed meets the minimum requirements of Solr (e.g. Java 8 for Solr 6+).

This role is currently tested and working with Solr 3.x, 4.x, 5.x and 6.x.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    solr_workspace: /root

Files will be downloaded to this path on the remote server before being moved into place.

    solr_create_user: true
    solr_user: solr

Solr will be run under the `solr_user`. Set `solr_create_user` to `false` if `solr_user` is created before this role runs, or if you're using Solr 5+ and want Solr's own installation script to set up the user.

    solr_version: "6.2.0"

The Apache Solr version to install. For a full list, see [available Apache Solr versions](http://archive.apache.org/dist/lucene/solr/).

    solr_mirror: "https://archive.apache.org/dist"

The Apache Project mirror from which the Solr tarball will be downloaded. In case of slow download speed or timeouts it is useful to set the mirror to the one suggested by Apache's [mirror download site](https://www.apache.org/dyn/closer.cgi/lucene/solr/).

    solr_install_dir: /opt
    solr_install_path: /opt/solr

The path where Apache Solr will be installed. For Solr 5+, the `solr_install_dir` will be used by Solr's installation script. For Solr < 5, the Solr installation files will be copied in place in the `solr_install_path`.

    solr_home: /var/solr

The path where local Solr data (search collections and configuration) will be stored. Should typically be outside of the `solr_path`, to make Solr upgrades easier.

    solr_port: "8983"

The port on which Solr will run.

    solr_xms: "256M"
    solr_xmx: "512M"

Memory settings for the JVM. These should be set as high as you can allow for best performance and to reduce the chance of Solr restarting itself due to OOM situations.

    solr_timezone: "UTC"

Default timezone of JVM running solr. You can override this if needed when using dataimport and delta imports (ex: comparing against a MySQL external data source). Read through Apache Solr's [Working with Dates](https://cwiki.apache.org/confluence/display/solr/Working+with+Dates) documentation for more background.

    solr_cores:
      - collection1

A list of cores / collections which should exist on the server. Each one will be created (if it doesn't exist already) using the default example configuration that ships with Solr. Note that this variable only applies when using Solr 5+.

### Variables used only for Solr < 5.

The following variables are currently only applied to installations of Solr 4 and below:

    solr_log_file_path: /var/log/solr.log

Path where Solr log file will be created.

    solr_host: "0.0.0.0"

The hostname or IP address to which Solr will bind. Defaults to `0.0.0.0` which allows Solr to listen on all interfaces.

## Dependencies

None.

## Example Playbook

    - hosts: solr-servers
      roles:
        - geerlingguy.java
        - geerlingguy.solr

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](http://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
