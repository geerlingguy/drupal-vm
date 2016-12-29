The [New Relic PHP agent](https://docs.newrelic.com/docs/agents/php-agent/getting-started/new-relic-php) monitors your application to help you identify and solve performance issues.

## Getting Started - Installing Prerequisites

To make New Relic available globally for all your projects within Drupal VM, make the following changes inside `config.yml`, then run `vagrant up` (or `vagrant provision` if the VM is already built):

```yaml
# Make sure newrelic is not commented out in the list of installed_extras:
installed_extras:
  [...]
  - newrelic
  [...]

# Set vars for your New Relic account:
# `newrelic` must be in installed_extras for this to work.
newrelic_license_key: yourkey
# Customize any additional vars relevant to your project needs.
# See all vars: https://github.com/weareinteractive/ansible-newrelic#variables
```

See [New Relic for PHP](https://docs.newrelic.com/docs/agents/php-agent/getting-started/new-relic-php) for help getting started.

For a list of available role variables, see the [`franklinkim.newrelic` Ansible role's README](https://github.com/weareinteractive/ansible-newrelic#readme).
