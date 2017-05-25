Drupal VM makes using Apache Solr easy; just make sure `solr` is in the list of `installed_extras` in your `config.yml`, and when you build Drupal VM, the latest version of Apache Solr will be installed.

Inside of Drupal, you can use any of the available Apache Solr integration modules (e.g. [Apache Solr Search](https://www.drupal.org/project/apachesolr) or [Search API Solr Search](https://www.drupal.org/project/search_api_solr)), and when you configure the modules, follow the installation instructions included with the module.

The URL to connect to the local solr server (assuming you're using the default `solr_port` of 8983) from Drupal is:

    http://localhost:8983/solr/collection1

This will connect to the default search core (`collection1`) set up by Solr. If you are using a multisite installation and want to have a search core per Drupal site, you can add more cores through Apache Solr's admin interface (visit `http://drupalvm.dev:8983/solr/`), then connect to each core by adding the core name to the end of the above URL (e.g. `core2` would be `http://localhost:8983/solr/core2`).

## Using Different Solr versions

Drupal VM installs Apache Solr 5.x by default, but you can use 6.x, 4.x, or other versions instead. To do this, [see the version-specific test examples](https://github.com/geerlingguy/ansible-role-solr/tree/master/tests) in the `geerlingguy.solr` role.

One important note: If you use Solr 5.x or 6.x (or later), you need to make sure your VM has Java 8+. By default, many of the supported OSes only install Java 7. To install Java 8, see the `geerlingguy.java` role examples for [installing Java 8 on RHEL/CentOS or Ubuntu < 16.04](https://github.com/geerlingguy/ansible-role-java#example-playbook-install-openjdk-8).

## Configuring the Solr search core for Drupal

Before Drupal content can be indexed correctly into Apache Solr, you will need to copy the Drupal Apache Solr Search or Search API Apache Solr configuration into place, and restart Apache Solr. Drupal VM comes with an example post provision script for automating this. Simply add it to `post_provision_scripts`:

```yaml
post_provision_scripts:
 - "../examples/scripts/configure-solr.sh"
```

Note that for Drupal 8, this script will create a new search core named `d8` (rather than modifying the default core `collection1`).

## Extra Solr configuration

You can add extra configuration for Solr, like the minimum and maximum memory allocation for the JVM (`solr_xms` and `solr_xmx`), and even the `solr_version`, by setting the appropriate variables inside `config.yml` before you build Drupal VM.

For a list of available role variables, see the [`geerlingguy.solr` Ansible role's README](https://github.com/geerlingguy/ansible-role-solr#readme).
