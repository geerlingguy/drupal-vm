# Ansible franklinkim.newrelic role

[![Build Status](https://img.shields.io/travis/weareinteractive/ansible-newrelic.svg)](https://travis-ci.org/weareinteractive/ansible-newrelic)
[![Galaxy](http://img.shields.io/badge/galaxy-franklinkim.newrelic-blue.svg)](https://galaxy.ansible.com/franklinkim/newrelic/)
[![GitHub Tags](https://img.shields.io/github/tag/weareinteractive/ansible-newrelic.svg)](https://github.com/weareinteractive/ansible-newrelic)
[![GitHub Stars](https://img.shields.io/github/stars/weareinteractive/ansible-newrelic.svg)](https://github.com/weareinteractive/ansible-newrelic)

> `franklinkim.newrelic` is an [Ansible](http://www.ansible.com) role which:
>
> * installs newrelic
> * configures newrelic
> * configures service

## Installation

Using `ansible-galaxy`:

```shell
$ ansible-galaxy install franklinkim.newrelic
```

Using `requirements.yml`:

```yaml
- src: franklinkim.newrelic
```

Using `git`:

```shell
$ git clone https://github.com/weareinteractive/ansible-newrelic.git franklinkim.newrelic
```

## Dependencies

* Ansible >= 2.0

## Variables

Here is a list of all the default variables for this role, which are also available in `defaults/main.yml`.

```yaml
---
#
# newrelic_license_key: yourkey

# User name
newrelic_user: newrelic
# User group
newrelic_group: newrelic
# User groups to append to user
newrelic_groups: []
# Name of the file where the server monitor will store it's log messages.
newrelic_logfile: /var/log/newrelic/nrsysmond.log
# Level of detail you want in the log file
newrelic_loglevel: info
# Set to true to disable NFS client statistics gathering.
newrelic_disable_nfs: yes
# Set to true to disable Docker container statistics gathering.
newrelic_disable_docker: yes
# start on boot
newrelic_service_enabled: yes
# current state: started, stopped
newrelic_service_state: started
# use default hostname, set a value to override the default hostname
newrelic_override_hostname: ~
# A series of label_type/label_value pairings: label_type:label_value
newrelic_labels:
# proxy server to use (i.e. proxy-host:8080)
newrelic_proxy:
# Option to fix Docker memory (see: https://discuss.newrelic.com/t/wrong-path-to-cpu-and-memoy-data/36177)
newrelic_cgroup_style:

```

## Handlers

These are the handlers that are defined in `handlers/main.yml`.

```yaml
---

- name: restart newrelic
  service:
    name: newrelic-sysmond
    state: restarted
  when: newrelic_service_state != 'stopped'

```


## Usage

This is an example playbook:

```yaml
---

- hosts: all
  become: yes
  roles:
    - franklinkim.newrelic
  vars:
    newrelic_service_state: started
    newrelic_license_key: ab2fa361cd4d0d373833cad619d7bcc424d27c16

```


## Testing

```shell
$ git clone https://github.com/weareinteractive/ansible-newrelic.git
$ cd ansible-newrelic
$ make test
```

## Contributing
In lieu of a formal style guide, take care to maintain the existing coding style. Add unit tests and examples for any new or changed functionality.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

*Note: To update the `README.md` file please install and run `ansible-role`:*

```shell
$ gem install ansible-role
$ ansible-role docgen
```

## License
Copyright (c) We Are Interactive under the MIT license.
