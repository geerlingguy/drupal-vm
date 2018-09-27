The [Tideways XHProf Extension](https://github.com/tideways/php-xhprof-extension) is a well-maintained fork of the XHProf code and works with either the [XHProf](https://www.drupal.org/project/xhprof) or [Tideways](https://www.drupal.org/project/tideways) Drupal modules to profile page views. Results can be viewed with these modules or the native XHProf UI.

Note that the Tideways project [recently split](https://tideways.com/profiler/blog/releasing-new-tideways-xhprof-extension) into a proprietary extension and a stand-alone fork of XHProf. DrupalVM (and this document) specifically uses the latter (the "Tideways XHProf Extension").

To use Tideways XHProf make sure `tideways` is in the list of `installed_extras`.

**Note**: You should only enable one code profiler at a time—e.g. when using [Blackfire](blackfire.md), disable [XHProf](xhprof.md), [Tideways](tideways.md) and [XDebug](xdebug.md).

### Profiling with the XHProf Drupal Module

To enable profiling of Drupal pages using the Tideways PHP Extension, follow the directions for [configuring the XHProf and the XHProf module](xhprof.md#xhprof-module), but choose the _Tideways_ extension under the _Profiling settings_ section.

### Profiling with the Tideways module

Instructions for profiling with the Tideways module through the [tideways.io](https://tideways.io) service will be added after the following issue is resolved: [Can't install latest dev release on 8.x](https://www.drupal.org/node/2843481).

For a list of available role variables, see the [`geerlingguy.php-tideways` Ansible role's README](https://github.com/geerlingguy/ansible-role-php-tideways#readme).

### Viewing results

As with the XHProf extension, you can view callgraphs (and a listing of all stored runs) using Drupal VM's own XHProf UI installation by visiting [http://xhprof.drupalvm.test/](http://xhprof.drupalvm.test) and clicking on the relevant run, then clicking the _[View Full Callgraph]_ link.

Note that if you have overridden DrupalVM's [default set of Apache vHosts](https://github.com/geerlingguy/drupal-vm/blob/master/default.config.yml), you will need to specifically add a vHost for the XHProf dashboard.
