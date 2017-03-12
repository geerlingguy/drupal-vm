[Elasticsearch](https://www.elastic.co/products/elasticsearch) is a search engine based on Lucene. It provides a distributed, multitenant-capable full-text search engine with an HTTP web interface and schema-free JSON documents.

To enable Elasticsearch in Drupal VM just make sure `elasticsearch` is in the list of `installed_extras` in your `config.yml`, and when you build Drupal VM, the latest version of Elasticsearch will be installed.

The URL to connect to the local elasticsearch server (assuming you're using the default `elasticsearch_http_port` of 9200) from Drupal is:

    http://localhost:9200

To access Elasticsearch from the host computer requires changing the IP address to listen on a specific interface, or 0.0.0.0 to listen on all interfaces.

    elasticsearch_network_host: 0.0.0.0

The Elasticsearch server can then be accessed at the configured domain:

    http://drupalvm.dev:9200

## Elasticsearch configuration

You can add configuration for Elasticsearch by setting the appropriate variables inside `config.yml` before you build Drupal VM.

    elasticsearch_network_host: localhost
    elasticsearch_http_port: 9200

For a list of available role variables, see the [`geerlingguy.elasticsearch` Ansible role's README](https://github.com/geerlingguy/ansible-role-elasticsearch#readme).
