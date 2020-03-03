<?php

/**
 * @file
 * Test if pecl/pear is available and working.
 */

require_once 'System.php';

$success = FALSE;

if (class_exists('System', false)) {
  $success = TRUE;
}

if (!$success) {
  print "pecl/pear not found.\r\n";
  exit(1);
}