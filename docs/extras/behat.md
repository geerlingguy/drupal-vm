Behat is an open source behavior-driven development tool for PHP. You can use Behat to build and run automated tests for site functionality on your Drupal sites, and Drupal VM has excellent built-in support for Behat, using Selenium to run tests in a headless instance of FireFox.

## Getting Started - Installing Prerequisites

To make Behat available globally for all your projects within Drupal VM, make the following changes inside `config.yml`, then run `vagrant up` (or `vagrant provision` if the VM is already built):

```yaml
# Make sure selenium is not commented out in the list of installed_extras:
installed_extras:
  [...]
  - selenium
  [...]

# Make sure the following four packages are in composer_global_packages:
composer_global_packages:
  - { name: behat/mink, release: '1.5.*@stable' }
  - { name: behat/mink-goutte-driver, release: '*' }
  - { name: behat/mink-selenium2-driver, release: '*' }
  - { name: drupal/drupal-extension, release: '*' }
```

After Drupal VM is finished provisioning, you should be able to log in and run the following command to make sure Behat is installed correctly:

```
$ behat --version
behat version 3.0.15
```

_You can also include the `behat/*` and `drupal/drupal-extension` directly in your project's `composer.json` file, and install the dependencies per-project. Either option (installing globally, like above, or installing per-project) is perfectly acceptable._

## Setting up Behat for your project

Using the default Drupal site as an example (it's installed in `/var/www/drupal` by default, and is shared to `~/Sites/drupalvm/drupal` on your host machine), the following steps will help you get your first Behat tests up and running!

  1. Create a `behat.yml` file inside the docroot of your site (e.g. create this file alongside the rest of the Drupal codebase at `/var/www/drupal/behat.yml`), with the following contents:

    ```
    default:
      suites:
        web_features:
          paths: [ %paths.base%/features/web ]
          contexts: [ WebContext ]
      extensions:
        Behat\MinkExtension:
          goutte: ~
          javascript_session: selenium2
          selenium2:
            wd_host: http://drupalvm.dev:4444/wd/hub
          base_url: http://drupalvm.dev
        Drupal\DrupalExtension:
          blackbox: ~
          api_driver: 'drupal'
          drupal:
            drupal_root: '/var/www/drupal'
    ```
  
  2. Log into Drupal VM with `vagrant ssh`, change directory to the Drupal site root (`cd /var/www/drupal`), then run `behat --init` to initialize the `features` folder where you will place test cases.
  3. From either inside the VM or on the host machine, open up the new `features` folder Behat just created, and create a new `drupal` folder inside. Inside _that_ folder, create `HomeContent.feature` with the following contents:

    ```
    Feature: Test DrupalContext
      In order to prove the Behat is working correctly in Drupal VM
      As a developer
      I need to run a simple interface test

      Scenario: Viewing content in a region
        Given I am on the homepage
        Then I should see "No front page content has been created yet" in the "content"

    ```
  
  4. Now, inside Drupal VM, change directory to `/var/www/drupal` again, and run the command `behat` (which runs all the tests you've created—which should just be one so far).

If everything was done correctly, you should see:

```
$ behat
Feature: Test DrupalContext
  In order to prove the Behat is working correctly in Drupal VM
  As a developer
  I need to run a simple interface test

  Scenario: Viewing content in a region                                             # features/drupal/HomeContent.feature:6
    Given I am on the homepage                                                      # Drupal\DrupalExtension\Context\MinkContext::iAmOnHomepage()
    Then I should see "No front page content has been created yet" in the "content" # Drupal\DrupalExtension\Context\MinkContext::assertRegionText()

1 scenario (1 passed)
2 steps (2 passed)
0m0.56s (26.48Mb)
```

Hooray! Now you're ready to get started testing ALL THE THINGS! Check out the following resources for more information about Behat and Drupal:

  - [Behat 3.0 Documentation](http://behat.readthedocs.org/en/v3.0/)
  - [Drupal Extension Documentation](https://behat-drupal-extension.readthedocs.org/en/3.0/)