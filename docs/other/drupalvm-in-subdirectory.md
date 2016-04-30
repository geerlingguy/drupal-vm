To make it easier bringing in Drupal VM updates to an existing project, you might consider a slightly more complex setup. Instead of mixing your project's files with Drupal VM's configuration files, you can separate the two with the help of a delegating `Vagrantfile`.

### Steps for setting up a decoupled project structure:

Add Drupal VM as a git submodule (or other) to a subdirectory, in this case we'll name the subdirectory `box/`.

```
├── docroot
│   ├── ...
│   └── index.php
└── box
    ├── ...
    ├── example.config.yml
    └── Vagrantfile
```

Add an configure the `config.yml` anywhere you like, in this example we'll place it in `config/drupalvm.config.yml`.

```
├── config
│   ├── ...
│   └── drupalvm.config.yml
├── docroot
│   ├── ...
│   └── index.php
└── box
    ├── ...
    ├── example.config.yml
    └── Vagrantfile
```

Create a delegating `Vagrantfile` with the environment variables `DRUPALVM_PROJECT_ROOT` and `DRUPALVM_CONFIG`. Place this file in your project's root directory.

```ruby
# The absolute path to the root directory of the project. Both Drupal VM and
# the config file need to be contained within this path.
ENV['DRUPALVM_PROJECT_ROOT'] = "#{__dir__}"
# The relative path from the project root to to config file.
ENV['DRUPALVM_CONFIG'] = "config/drupalvm.config.yml"
# Load the real Vagrantfile
load "#{__dir__}/box/Vagrantfile"
```

```
├───Vagrantfile
├── config
│   ├── ...
│   └── drupalvm.config.yml
├── docroot
│   ├── ...
│   └── index.php
└── box
    ├── ...
    ├── example.config.yml
    └── Vagrantfile
```

When you issue `vagrant` commands anywhere in your project tree this file will be detected and used as a delegator for Drupal VM's own Vagrantfile.

Finally, provision the VM using the delegating `Vagrantfile`. _Important_, you should never issue `vagrant` commands through the `box/Vagrantfile` directly. If you do, it will create a secondary VM in the `box/` directory.

```sh
vagrant up
```
