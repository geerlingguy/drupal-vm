If you have Drush installed on your host workstation, and would like to interact with a Drupal site running inside Drupal VM, there are drush aliases automatically created by Drupal VM for each of the virtual hosts you have configured.

With the example configuration, you can manage the example Drupal site using the Drush alias `@drupaltest.dev`. For example, to check if Drush can connect to the site in Drupal VM, run:

```
$ drush @drupaltest.dev status
 Drupal version         :  8.0.0-dev                                                                                    
 Site URI               :  drupaltest.dev                                                                               
 Database driver        :  mysql                                                                                        
 Database hostname      :  localhost                                                                                    
 Database port          :                                                                                               
 Database username      :  drupal                                                                                       
 Database name          :  drupal                                                                                       
 Database               :  Connected                                                                                    
 Drupal bootstrap       :  Successful                                                                                   
 Drupal user            :  Anonymous                                                                                    
 Default theme          :  bartik                                                                                       
 Administration theme   :  seven                                                                                        
 PHP executable         :  /usr/bin/php                                                                                 
 PHP configuration      :  /etc/php5/cli/php.ini                                                                        
 PHP OS                 :  Linux                                                                                        
 Drush script           :  /usr/local/share/drush/drush.php                                                             
 Drush version          :  7.0-dev                                                                                      
 Drush temp directory   :  /tmp                                                                                         
 Drush configuration    :                                                                                               
 Drush alias files      :                                                                                               
 Drupal root            :  /var/www/drupal                                                                              
 Site path              :  sites/default                                                                                
 File directory path    :  sites/default/files                                                                          
 Temporary file         :  /tmp                                                                                         
 directory path                                                                                                         
 Active config path     :  [...]
 Staging config path    :  [...]
```

Drupal VM automatically generates a drush alias file in `~/.drush/drupalvm.aliases.drushrc.php` with an alias for every site you have defined in the `apache_vhosts` variable.

You can disable Drupal VM's automatic Drush alias file management if you want to manage drush aliases on your own. Just set the `configure_local_drush_aliases` variable in `config.yml` to `false`.