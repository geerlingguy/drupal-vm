# Ansible Role: PostgreSQL

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-postgresql.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-postgresql)

Installs and configures PostgreSQL server on RHEL/CentOS or Debian/Ubuntu servers.

## Requirements

No special requirements; note that this role requires root access, so either run it in a playbook with a global `become: yes`, or invoke the role in your playbook like:

    - hosts: database
      roles:
        - role: geerlingguy.postgresql
          become: yes

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    postgresql_enablerepo: ""

(RHEL/CentOS only) You can set a repo to use for the PostgreSQL installation by passing it in here.

    postgresql_python_library: python-psycopg2

Library used by Ansible to communicate with PostgreSQL. If you are using Python 3 (e.g. set via `ansible_python_interpreter`), you should change this to `python3-psycopg2`.

    postgresql_user: postgres
    postgresql_group: postgres

The user and group under which PostgreSQL will run.

    postgresql_unix_socket_directories:
      - /var/run/postgresql

The directories (usually one, but can be multiple) where PostgreSQL's socket will be created.

    postgresql_global_config_options:
      - option: unix_socket_directories
        value: '{{ postgresql_unix_socket_directories | join(",") }}'

Global configuration options that will be set in `postgresql.conf`. Note that for RHEL/CentOS 6 (or very old versions of PostgreSQL), you need to at least override this variable and set the `option` to `unix_socket_directory`.

    postgresql_hba_entries:
      - { type: local, database: all, user: postgres, auth_method: peer }
      - { type: local, database: all, user: all, auth_method: peer }
      - { type: host, database: all, user: all, address: '127.0.0.1/32', auth_method: md5 }
      - { type: host, database: all, user: all, address: '::1/128', auth_method: md5 }

Configure [host based authentication](https://www.postgresql.org/docs/current/static/auth-pg-hba-conf.html) entries to be set in the `pg_hba.conf`. Options for entries include:

  - `type` (required)
  - `database` (required)
  - `user` (required)
  - `address` (one of this or the following two are required)
  - `ip_address`
  - `ip_mask`
  - `auth_method` (required)
  - `auth_options` (optional)

If overriding, make sure you copy all of the existing entries from `defaults/main.yml` if you need to preserve existing entries.

    postgresql_locales:
      - 'en_US.UTF-8'

(Debian/Ubuntu only) Used to generate the locales used by PostgreSQL databases.

    postgresql_databases:
      - name: exampledb # required; the rest are optional
        lc_collate: # defaults to 'en_US.UTF-8'
        lc_ctype: # defaults to 'en_US.UTF-8'
        encoding: # defaults to 'UTF-8'
        template: # defaults to 'template0'
        login_host: # defaults to 'localhost'
        login_password: # defaults to not set
        login_user: # defaults to 'postgresql_user'
        login_unix_socket: # defaults to 1st of postgresql_unix_socket_directories
        port: # defaults to not set
        state: # defaults to 'present'

A list of databases to ensure exist on the server. Only the `name` is required; all other properties are optional.

    postgresql_users:
      - name: jdoe #required; the rest are optional
        password: # defaults to not set
        priv: # defaults to not set
        role_attr_flags: # defaults to not set
        db: # defaults to not set
        login_host: # defaults to 'localhost'
        login_password: # defaults to not set
        login_user: # defaults to '{{ postgresql_user }}'
        login_unix_socket: # defaults to 1st of postgresql_unix_socket_directories
        port: # defaults to not set
        state: # defaults to 'present'

A list of users to ensure exist on the server. Only the `name` is required; all other properties are optional.

    postgresql_version: [OS-specific]
    postgresql_data_dir: [OS-specific]
    postgresql_bin_path: [OS-specific]
    postgresql_config_path: [OS-specific]
    postgresql_daemon: [OS-specific]
    postgresql_packages: [OS-specific]

OS-specific variables that are set by include files in this role's `vars` directory. These shouldn't be overridden unless you're using a verison of PostgreSQL that wasn't installed using system packages.

## Dependencies

None.

## Example Playbook

    - hosts: database
      become: yes
      vars_files:
        - vars/main.yml
      roles:
        - geerlingguy.postgresql

*Inside `vars/main.yml`*:

    postgresql_databases:
      - name: example_db
    postgresql_users:
      - name: example_user
        password: supersecure

## License

MIT / BSD

## Author Information

This role was created in 2016 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
