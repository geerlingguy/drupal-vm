The Tideways PHP Extension is a well-maintained fork of the XHProf code and works with either the [XHProf](https://www.drupal.org/project/xhprof) or [Tideways](https://www.drupal.org/project/tideways) module to profile page views.

To use Tideways make sure `tideways` is in the list of `installed_extras`.

**Note**: You should only enable one code profiler at a time—e.g. when using [Blackfire](blackfire.md), disable [XHProf](xhprof.md), [Tideways](tideways.md) and [XDebug](xdebug.md).

### Profiling with the XHProf Module

To enable profiling of Drupal pages using the Tideways PHP Extension, follow the directions for [configuring the XHProf and the XHProf module](xhprof.md#xhprof-module), but choose the _Tideways_ extension under the _Profiling settings_ section.

As with the XHProf extension, you can view callgraphs (and a listing of all stored runs) using Drupal VM's own XHProf UI installation by visiting [http://xhprof.drupalvm.dev/](http://xhprof.drupalvm.dev) and clicking on the relevant run, then clicking the _[View Full Callgraph]_ link.

### Profiling with the Tideways module

Instructions for profiling with the Tideways module through the [tideways.io](https://tideways.io) service will be added after the following issue is resolved: [Can't install latest dev release on 8.x](https://www.drupal.org/node/2843481).

For a list of available role variables, see the [`geerlingguy.php-tideways` Ansible role's README](https://github.com/geerlingguy/ansible-role-php-tideways#readme).
