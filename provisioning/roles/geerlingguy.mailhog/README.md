# Ansible Role: MailHog

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-mailhog.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-mailhog)

Installs [MailHog](https://github.com/mailhog/MailHog), a Go-based SMTP server and web UI/API for displaying captured emails, on RedHat or Debian-based linux systems.

Also installs [mhsendmail](https://github.com/mailhog/mhsendmail) so you can redirect system mail to MailHog's built-in SMTP server.

If you're using PHP and would like to route all PHP email into MailHog, you will need to update the `sendmail_path` configuration option in php.ini, like so:

    sendmail_path = "{{ mailhog_install_dir }}/mhsendmail"

(Replace `{{ mailhog_install_dir }}` with the actual MailHog installation directory, which is `/opt/mailhog` by default—e.g. `/opt/mailhog/mhsendmail`).

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    mailhog_install_dir: /opt/mailhog

The directory into which the MailHog binary will be installed.

    mailhog_binary_url: https://github.com/mailhog/MailHog/releases/download/v0.2.1/MailHog_linux_amd64

The MailHog binary that will be installed. You can find the latest version or a 32-bit version by visiting the [MailHog project releases page](https://github.com/mailhog/MailHog/releases).

    mailhog_daemonize_bin_path: /usr/sbin/daemonize

The path to `daemonize`, which is used to launch MailHog via init script.

    mhsendmail_binary_url: https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64

The mhsendmail binary that will be installed. You can find the latest version or a 32-bit version by visiting the [mhsendmail project releases page](https://github.com/mailhog/mhsendmail/releases).

## Dependencies

  - geerlingguy.daemonize

## Example Playbook

    - hosts: servers
      roles:
        - { role: geerlingguy.mailhog }

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
