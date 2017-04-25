If you're using Drupal VM as a Composer dependency and need to patch something that you're otherwise unable to configure, you can do so with the help of the [`composer-patches` plugin](https://github.com/cweagans/composer-patches).

Grab a clone of the Drupal VM version your project is using:

    git clone https://github.com/geerlingguy/drupal-vm.git drupal-vm
    cd drupal-vm
    git checkout 5.0.0

Make the changes you need and create a patch using `git diff`:

    git diff --cached > custom-roles.patch

Move this file to your project somewhere, eg. `vm/patches/custom-roles.patch`.

Require the [`composer-patches` plugin](https://github.com/cweagans/composer-patches) as a dependency to your project unless you already have it:

    composer require cweagans/composer-patches

Add the patch to the `extra`-field in your `composer.json`:

    {
      "extra": {
        "patches": {
          "geerlingguy/drupal-vm": {
            "Include custom Drupal VM roles": "vm/patches/custom-roles.patch"
          }
        }
      }
    }

Re-install the Drupal VM package to apply the patch:

    composer remove --dev geerlingguy/drupal-vm
    composer require --dev geerlingguy/drupal-vm:5.0.0

Your Drupal VM version is now been patched!
