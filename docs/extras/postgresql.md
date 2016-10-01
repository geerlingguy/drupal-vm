Since Drupal VM is built in a modular fashion, you can swap out the database engine and use [PostgreSQL](https://www.postgresql.org/) instead of MySQL (as long as the version of Drupal you're using supports it!).

To switch from MySQL to PostgreSQL, switch the `drupalvm_database` setting in your local `config.yml` to `pgsql`:

```yaml
drupalvm_database: pgsql
```

For more PostgreSQL configuration options, see the README included with the [`geerlingguy.postgresql`](https://galaxy.ansible.com/geerlingguy/postgresql/) Ansible role.
