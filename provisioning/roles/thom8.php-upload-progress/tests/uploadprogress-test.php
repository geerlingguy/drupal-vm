<?php

/**
 * @file
 * Test if Upload progress is available and working.
 */

$success = FALSE;

// Check uploadprogress extension is loaded.
if (extension_loaded('uploadprogress')) {
  $success = TRUE;
  print "Upload progress working properly.\r\n";
  exit(0);
}

if (!$success) {
  print "Upload progress not working properly.\r\n";
  exit(1);
}
