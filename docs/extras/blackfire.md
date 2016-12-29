[Blackfire.io](https://blackfire.io/) is a service that allows code profiling to be stored and analyzed via an online profile on the Blackfire.io website.

It doesn't require any additional Drupal modules to use, but once you've made sure `blackfire` is in the list of `installed_extras` in `config.yml` (and Drupal VM has been provisioned), you need to log into Drupal VM and [run the setup steps outlined on the Blackfire Ansible role's README](https://github.com/geerlingguy/ansible-role-blackfire#requirements).

**Note**: You should only enable one code profiler at a time—e.g. when using [Blackfire](blackfire.md), disable [XHProf](xhprof.md), [Tideways](tideways.md) and [XDebug](xdebug.md).

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

For a list of available role variables, see the [`geerlingguy.blackfire` Ansible role's README](https://github.com/geerlingguy/ansible-role-blackfire#readme).
