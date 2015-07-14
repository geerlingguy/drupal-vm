@rgoodie created a function called `newd` that clones this repo, uses `sed` to change configuration to Drupal 7 if desired, renames the VM to something other than drupaltest.dev, and kicks off `vagrant up`.

Example:

```
# Create a new Drupal VM named 'test-fieldformatter' with Drupal 7.
$ newd 7 test-fieldformatter

# Create a new Drupal VM named 'drupal8test' with Drupal 8.
$ newd 8 drupal8test
```

The source code for this new bash function (you could add it to your own `.bash_profile` or `.profile`) is located here: https://gist.github.com/rgoodie/9966f30b404a4daa59e1

Do you have your own wrapper script or other helpers to help you manage instances of Drupal VM? Please share it on this page!