Drupal VM's configuration works with multiple operating systems _and_ with multiple webservers. You can switch between Apache and Nginx (depending on which server you prefer) with ease.

All you need to do is change the `drupalvm_webserver` variable inside your customized `config.yml`, choosing either `apache` or `nginx`.

Because the webservers are configured somewhat differently, there are a few things you should configure depending on which webserver you use.

## Using Apache

You have complete control over all aspects of Apache VirtualHosts using the `apache_vhosts` configuration. A few simple examples are shown in `default.config.yml`, but this configuration can be much more complex.

See the examples included in the [`geerlingguy.apache` Ansible role's README](https://github.com/geerlingguy/ansible-role-apache#readme) for more info, as well as many other variables you can override to configure Apache exactly how you like it.

## Using Nginx

Because Nginx server directives behave a little differently than Apache's VirtualHosts, Drupal VM includes a custom Drupal-optimized Nginx server block configuration, and you can control all the servers ('virtual hosts') Nginx will run using the `nginx_hosts` configuration. A few simple examples are shown in `default.config.yml`, but you have some extra flexibility if you need it. See the `nginx-vhost.conf.j2` template for more information.

Also, see the examples included in the [`geerlingguy.nginx` Ansible role's README](https://github.com/geerlingguy/ansible-role-nginx#readme) for more info, as well as many other variables you can override to configure Nginx exactly how you like it. 

Note: if you're using php-fpm, you may want to reflect your use of nginx by setting `php_fpm_pool_user` and `php_fpm_pool_group` in your `config.yml`. 
