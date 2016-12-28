You can profile your code using one of the supported profiling tools included in Drupal VM.

As a prerequisite, you need to make sure the profiler you'd like to use is listed (and not commented out) in `installed_extras` inside `config.yml` (So the appropriate software is installed on Drupal VM).

**Note**: You should only enable one code profiler at a time—e.g. when using Blackfire, disable XHProf and XDebug.

## Blackfire

[Blackfire.io](https://blackfire.io/) is a service that allows code profiling to be stored and analyzed via an online profile on the Blackfire.io website.

It doesn't require any additional Drupal modules to use, but once you've made sure `blackfire` is in the list of `installed_extras` in `config.yml` (and Drupal VM has been provisioned), you need to log into Drupal VM and [run the setup steps outlined on the Blackfire Ansible role's README](https://github.com/geerlingguy/ansible-role-blackfire#requirements).

Once you've configured your environment for your own Blackfire account, you can profile a request with Blackfire by running something like the following example (within Drupal VM, after logging in with `vagrant ssh`):

```
$ blackfire curl http://drupalvm.dev/
Profiling: [########################################] 10/10
Blackfire cURL completed
Graph URL https://blackfire.io/profiles/[UUID]/graph

Wall Time     151ms
CPU Time      130ms
I/O Time     20.9ms
Memory        1.5MB
Network         n/a     n/a       -
SQL             n/a       -
```

## XHProf

[XHProf](http://xhprof.io/) allows easy code profiling and can be used in many different ways. Ensure `xhprof` is in the list of `installed_extras` inside `config.yml`.

_Note: XHProf does currently not work with PHP 7.1._

### XHProf module

The easiest way to use XHProf to profile your PHP code on a Drupal site is to install the [XHProf](https://www.drupal.org/project/xhprof) module, then in XHProf's configuration (at `/admin/config/development/xhprof`), check the 'Enable profiling of page views and drush requests' checkbox.

The XHProf module doesn't include built-in support for callgraphs, but there's an issue to [add callgraph support](https://www.drupal.org/node/1470740).

You can view callgraphs (and a listing of all stored runs) using Drupal VM's own XHProf installation by visiting `http://xhprof.drupalvm.dev/` and clicking on the relevant run, then clicking the "[View Full Callgraph]" link.

### Devel module (deprecated)

The Devel module also *used* to provide XHProf configuration, and setting the options below would allow Devel's XHProf integration to work correctly with Drupal VM's XHProf installation:

  - **xhprof directory**: `/usr/share/php`
  - **XHProf URL**: `http://xhprof.drupalvm.dev` (assuming this domain is configured in `apache_vhosts` inside `config.yml`)

## XDebug

[XDebug](https://xdebug.org/) is a debugger and profiler for PHP. While most people use it only for debugging purposes, you can also use it for profiling. It's not as commonly used for profiling as either Blackfire or XHProf, but it works!
