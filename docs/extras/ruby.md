Ruby is used for many different purposes, but with Drupal, it is most often used as part of a toolset for Front End development or certain CI tasks.

Drupal VM includes built-in support for Ruby—all you need to do is make sure `ruby` is listed in the list of `installed_extras` inside `config.yml` before your provision Drupal VM.

## Installing gems

To install ruby gems, you can add them to the list of `ruby_install_gems` in `config.yml`.

```yaml
ruby_install_gems:
  - sass
  - compass
```

For a list of available role variables, see the [`geerlingguy.ruby` Ansible role's README](https://github.com/geerlingguy/ansible-role-ruby#readme).
