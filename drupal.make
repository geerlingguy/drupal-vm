; Basic Drush Make file for Drupal. Be sure to update the drupal_major_version
; variable inside provisioning/vars/main.yml if you change the major version in
; this file.

; Drupal core (major version, e.g. 6.x, 7.x, 8.x).
core = 8.x

; Drush Make API version.
api = 2

; Method 1 - Install Drupal core version directly (e.g. 6.29, 7.x, 7.30, 8.0.x).
; Note: This method doesn't currently work with semantic versioning with Drush.
; (see: https://github.com/drush-ops/drush/issues/896).
; projects[drupal][version] = 8.0.x

; Alternatively, use git.
projects[drupal][download][type] = git
projects[drupal][download][url] = http://git.drupal.org/project/drupal.git
projects[drupal][download][branch] = 8.0.x
; projects[drupal][download][tag] = 8.0.0-beta2
; projects[drupal][download][revision] = xyz

; Contrib modules
projects[] = devel
