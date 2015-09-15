[LiveReload](http://livereload.com/) is a Desktop app + browser extension that:

- Applies CSS and JavaScript file changes without reloading a page.
- Automatically reloads a page when any other file changes (html, image, server-side script, etc).

To enable live reloading:

- Setup port forwarding from the host to the guest machine on port 35729.

  ```yaml
  vagrant_forwarded_ports:
    # Enable livereload.
    - {guest: 35729, host: 35729, protocol: "tcp"}
  ```

- Trigger a reload event through the livereload desktop app or a livereload server (such as [grunt-contrib-watch](https://github.com/gruntjs/grunt-contrib-watch) or [Guard::LiveReload](https://github.com/guard/guard-livereload)).
- Install one of the [browser extensions](http://go.livereload.com/extensions).

## Mobile Devices

To make LiveReload work on mobile devices you need to load a `livereload.js` on each page, for an easy solution you can use the [LiveReload Drupal module](https://www.drupal.org/project/livereload). This makes the browser extensions obsolete and adds live reloading for all visitors.
