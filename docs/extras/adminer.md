If you have `adminer` listed as one of the `installed_extras` inside `config.yml`, you can use Adminer's web-based interface to interact with databases. With Drupal VM running, visit [http://adminer.drupalvm.dev/](http://adminer.drupalvm.dev/), and log in with `drupal` as the username and the password you set in `config.yml` (`drupal_db_password`). Leave the "Server" field blank. The "Database" field is optional.

For a list of available role variables, see the [`geerlingguy.adminer` Ansible role's README](https://github.com/geerlingguy/ansible-role-adminer#readme).
