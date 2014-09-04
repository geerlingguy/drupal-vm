; Basic Drush Make file for Drupal. Be sure to update the drupal_major_version
; variable inside provisioning/vars/main.yml if you change the major version in
; this file.

; Drupal core (major version, e.g. 6.x, 7.x, 8.x).
core = 7.x

; Drush Make API version.
api = 2

; Drupal core (e.g. 6.29, 7.x, 7.30, 8.0.x, etc.)
projects[drupal][version] = 7.x

; Contrib modules
projects[] = devel
