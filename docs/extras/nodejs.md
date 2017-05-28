Node.js is used for many different purposes, but with Drupal, it is most often used as part of a toolset for Front End development or certain CI tasks.

Drupal VM includes built-in support for Node.js—all you need to do is make sure `nodejs` is listed in the list of `installed_extras` inside `config.yml` before your provision Drupal VM.

## Choosing a version of Node.js

You can choose a version of Node.js to install using the `nodejs_version` variable in `config.yml`. See the [`geerlingguy.nodejs` Ansible role's README](https://github.com/geerlingguy/ansible-role-nodejs#readme) for all the currently-available versions for your OS.

```yaml
nodejs_version: "0.12"
```

## Installing global packages via NPM

To install packages globally, you can add them to the list of `nodejs_npm_global_packages` in `config.yml`. As an example, many developers use `phantomjs` as a ghost web driver for Behat tests inside Drupal VM. To install it globally, add it to the list:

```yaml
nodejs_npm_global_packages:
  - phantomjs
```

You can even specify a specific version to install:

```yaml
nodejs_npm_global_packages:
  - name: phantomjs
    version: 2.1.7
```

For a list of available role variables, see the [`geerlingguy.nodejs` Ansible role's README](https://github.com/geerlingguy/ansible-role-nodejs#readme).
