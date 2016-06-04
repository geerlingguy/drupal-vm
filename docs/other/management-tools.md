There are some upstream tools which aid in the creation and management of Drupal VM instances. Some of the more popular tools are listed here.

If you know of any other tools to help manage Drupal VM, please add them to this page!

## Lunchbox

[Lunchbox](https://github.com/LunchboxDevTools/lunchbox) is a wrapper for the Drupal VM project to manage your Drupal development process. It is a Node.js-based GUI to assist in setting up Drupal VM and creating and managing instances.

## Acquia BLT

[BLT (Build and Launch Tool)](https://github.com/acquia/blt) is a project from Acquia that builds a Drupal project repository, and can optionally include Drupal VM as part of the project. There is an open PR that may [use Composer to add Drupal VM as a project dependency automatically](https://github.com/acquia/blt/pull/93).

## Drupal VM Config Generator

[Drupal VM Config Generator](https://github.com/opdavies/drupal-vm-config-generator) is a Symfony Console application that manages and customises configuration files for Drupal VM projects.

You can either use the interactive console UI to build configurations, or pass options directly to the `drupalvm-generate` command.

Examples:

```
drupalvm-generate \
  --hostname=example.com \
  --machine-name=example \
  --ip-address=192.168.88.88 \
  --cpus=1 \
  --memory=512 \
  --webserver=nginx \
  --domain=example.com \
  --path=../site \
  --destination=/var/www/site \
  --docroot=/var/www/site/drupal \
  --drupal-version=8 \
  --build-makefile=no \
  --install-site=true \
  --installed-extras=xdebug,xhprof \
  --force
```

## Drupal VM Generator

[generator-drupalvm](https://github.com/kevinquillen/generator-drupalvm) is a Yeoman generator for quickly spawning configured VMs or new projects using Drupal VM.

Examples:

```
# Generate a new Drupal VM instance in the current directory.
$ yo drupalvm
```

## Newd

[`newd`](https://gist.github.com/rgoodie/9966f30b404a4daa59e1) is a bash function that quickly clones the Drupal VM repo wherever you need it, configures important bits, and then kicks off `vagrant up`.

Examples:

```
# Create a new Drupal VM named 'test-fieldformatter' with Drupal 7.
$ newd 7 test-fieldformatter

# Create a new Drupal VM named 'drupal8test' with Drupal 8.
$ newd 8 drupal8test
```
