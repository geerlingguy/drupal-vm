Behat is an open source behavior-driven development tool for PHP. You can use Behat to build and run automated tests for site functionality on your Drupal sites, and Drupal VM has excellent built-in support for Behat, using Selenium to run tests in a headless instance of either Google Chrome (default) or Firefox.

## Getting Started - Installing Prerequisites

To make Behat available globally for all your projects within Drupal VM, make the following changes inside `config.yml`, then run `vagrant up` (or `vagrant provision` if the VM is already built):

```yaml
# Make sure selenium is not commented out in the list of installed_extras:
installed_extras:
  [...]
  - selenium
  [...]

# Add the following package to composer_global_packages or your Drupal project:
composer_global_packages:
  - { name: drupal/drupal-extension, release: '*' }
```

After Drupal VM is finished provisioning, you should be able to log in and run the following command to make sure Behat is installed correctly:

```
$ behat --version
behat version 3.0.15
```

_You can also include `drupal/drupal-extension` directly in your project's `composer.json` file, and install the dependencies per-project._

## Setting up Behat for your project

Using the default Drupal site as an example (it's installed in `/var/www/drupalvm/drupal` by default, and is shared to the `./drupal` folder inside the drupal-vm directory on your host machine), the following steps will help you get your first Behat tests up and running!

  1. Create a `behat.yml` file inside the docroot of your site (e.g. create this file alongside the rest of the Drupal codebase at `/var/www/drupalvm/drupal/behat.yml`), with the following contents:

        default:
          suites:
            web_features:
              paths: [ %paths.base%/features/web ]
              contexts:
                - WebContext
                - Drupal\DrupalExtension\Context\DrupalContext
                - Drupal\DrupalExtension\Context\MinkContext
                - Drupal\DrupalExtension\Context\MessageContext
                - Drupal\DrupalExtension\Context\DrushContext
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
                drupal_root: '/var/www/drupalvm/drupal/web'
              region_map:
                content: "#content"

  2. Log into Drupal VM with `vagrant ssh`, change directory to the Drupal site root (`cd /var/www/drupalvm/drupal`), then run `behat --init` to initialize the `features` folder where you will place test cases.
  3. From either inside the VM or on the host machine, open up the new `features/web` folder Behat just created. Inside _that_ folder, create `HomeContent.feature` with the following contents:

        Feature: Test DrupalContext
          In order to prove Behat is working correctly in Drupal VM
          As a developer
          I need to run a simple interface test

          Scenario: Viewing content in a region
            Given I am on the homepage
            Then I should see "No front page content has been created yet" in the "content"

  4. Now, inside Drupal VM, change directory to `/var/www/drupalvm/drupal` again, and run the command `behat` (which runs all the tests you've created—which should just be one so far).

If everything was done correctly, you should see:

```console
$ behat
Feature: Test DrupalContext
  In order to prove Behat is working correctly in Drupal VM
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

## Debugging issues

There are many different ways you can run Behat tests via PhantomJS and other drivers, and some people have encountered issues and workarounds with different approaches. Here are some relevant issues you can read through for more background:

  - [Selenium Questions](https://github.com/geerlingguy/drupal-vm/issues/367)
  - [Trying to achieve a Visual Regression Testing Strategy](https://github.com/geerlingguy/drupal-vm/issues/421)

Also, see Acquia's [BLT](https://github.com/acquia/blt) project for a good example of Behat test integration with Drupal VM.

For a list of available role variables, see the [`arknoll.selenium` Ansible role's README](https://github.com/arknoll/ansible-role-selenium#readme).
