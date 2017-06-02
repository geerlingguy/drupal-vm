There are two supported methods of integrating Drupal VM with your site. You can either download Drupal VM and integrate your site inside the project, or you can add Drupal VM as a Composer dependency to your existing project.

## Download Drupal VM and integrate your project.

The easiest way to get started with Drupal VM is to download the [latest release](https://www.drupalvm.com/), open the terminal, `cd` to the directory, and type `vagrant up`.

Using this method you have various options of how your site will be built, or if it will be built by Drupal VM at all:

- [Build using a local codebase](../deployment/local-codebase.md)
- [Build using a Composer package](../deployment/composer-package.md) (default)
- [Build using a composer.json](../deployment/composer.md)
- [Build using a Drush Make file](../deployment/drush-make.md)
- [Deploy Drupal via Git](../deployment/git.md)

## Add Drupal VM as a Composer depedency to an existing project

_If you're using Composer to manage your project, having Drupal VM as dependency makes it easier to pull in future updates._

Using this method you only have one option of how your site will be built, it will be built using your parent project's `composer.json` file.

- [Add Drupal VM to your project using Composer](../deployment/composer-dependency.md)
