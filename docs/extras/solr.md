Drupal VM makes using Apache Solr easy; just make sure `solr` is in the list of `installed_extras` in your `config.yml`, and when you build Drupal VM, the latest version of Apache Solr will be installed.

Inside of Drupal, you can use any of the available Apache Solr integration modules (e.g. [Apache Solr Search](https://www.drupal.org/project/apachesolr) or [Search API Solr Search](https://www.drupal.org/project/search_api_solr)), and when you configure the modules, follow the installation instructions included with the module.

The URL to connect to the local solr server (assuming you're using the default `solr_port` of 8983) from Drupal is:

    http://localhost:8983/solr/collection1

This will connect to the default search core (`collection1`) set up by Solr. If you are using a multisite installation and want to have a search core per Drupal site, you can add more cores through Apache Solr's admin interface (visit `http://drupaltest.dev:8983/solr/`), then connect to each core by adding the core name to the end of the above URL (e.g. `core2` would be `http://localhost:8983/solr/core2`).

## Configuring the Solr search core for Drupal

Before Drupal content can be indexed correctly into Apache Solr, you will need to copy the Drupal Apache Solr Search or Search API Apache Solr configuration into place, and restart Apache Solr. This process will soon be automated, but for now, please perform the steps outlined in step 5 in this blog post (which should work with Drupal VM): [Solr for Drupal Developers, Part 3: Testing Solr locally](http://www.midwesternmac.com/blogs/jeff-geerling/solr-drupal-developers-part-3).

## Extra Solr configuration

You can add extra configuration for Solr, like the minimum and maximum memory allocation for the JVM (`solr_xms` and `solr_xmx`), and even the `solr_version`, by setting the appropriate variables inside `config.yml` before you build Drupal VM.