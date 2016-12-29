By default, Drupal VM redirects all PHP emails to [MailHog](https://github.com/mailhog/MailHog) (instead of sending them to the outside world). You can access the MailHog UI at [http://drupalvm.dev:8025/](http://drupalvm.dev:8025) (or whatever domain you have configured in `config.yml`).

## Disable MailHog

If you don't want to use MailHog, you can set the following override (back to PHP's default, as defined in the [`geerlingguy.php`](https://github.com/geerlingguy/ansible-role-php#role-variables) role) in your `config.yml` file:

```yaml
php_sendmail_path: "/usr/sbin/sendmail -t -i"
```

After doing this, you can also prevent MailHog's installation by removing `mailhog` from the `installed_extras` list.

For a list of available role variables, see the [`geerlingguy.mailhog` Ansible role's README](https://github.com/geerlingguy/ansible-role-mailhog#readme).
