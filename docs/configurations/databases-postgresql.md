Since Drupal VM is built in a modular fashion, you can swap out the database engine and use [PostgreSQL](https://www.postgresql.org/) instead of MySQL (as long as the version of Drupal you're using supports it!).

To switch from MySQL to PostgreSQL, switch the `drupal_db_backend` setting in your local `config.yml` to `pgsql`:

```yaml
drupal_db_backend: pgsql
```

For more PostgreSQL configuration options, see the [`geerlingguy.postgresql` Ansible role's README](https://github.com/geerlingguy/ansible-role-postgresql#readme).
