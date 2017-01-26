If you only need a simple Drupal VM environment up and running there are no required configurations. The [configurations used by default are listed in `default.config.yml`](https://github.com/geerlingguy/drupal-vm/blob/master/default.config.yml) and you can override them with a number of optional configuration files.

_Note: The merge of variables in these files is shallow, if you want to override a single item in a list, you will need to re-define all items in that list._

Configurations files are read in the following order:

#### 1. default.config.yml

Drupal VM's default configurations which you should not edit directly.

#### 2. config.yml

The main configuration file of a project. Commonly this is a copy of `default.config.yml` with the values tweaked to your own project. For an easier upgrade path you would only set the values you are actually overriding.

```yaml
vagrant_box: geerlingguy/centos7
vagrant_hostname: my-custom-site.dev
vagrant_machine_name: my_custom_site

php_version: "5.6"
```

#### 3. local.config.yml

Local development overrides. Commonly this file is ignored from VCS so that each team member can make local customizations.

```yaml
# Increase the memory available to your Drupal site.
vagrant_memory: 1536
php_memory_limit: "512M"

# Override the synced folders to use rsync instead of NFS.
vagrant_synced_folders:
  - local_path: .
    destination: /var/www/drupalvm
    type: rsync
    create: true
```

### 4. vagrant.config.yml

Environment specific overrides. When you run Drupal VM through _Vagrant_, the environment will be set to `vagrant` and this file is loaded when available. If you're doing something more advanced, such as running Drupal VM on a [production environment](../other/production.md), you can use a different environment configuration file, eg `prod.config.yml`.

_Note: In addition to the variables listed in `default.config.yml`, you can also override the variables set by any of the ansible roles. In the "Installed extras" section of this documentation, each role has a link to the available variables._

## Additional resources

- Jeff Geerling's DrupalDC talk "[Drupal VM Tips and Tricks for Drupal 8 development](https://www.youtube.com/watch?v=_wV6MDsT42Y)"
