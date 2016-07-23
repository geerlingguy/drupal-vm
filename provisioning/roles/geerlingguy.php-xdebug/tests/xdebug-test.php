<?php

/**
 * @file
 * Test if Xdebug is available and working.
 */

$success = FALSE;

// Simple check; this function should return an empty array.
$test = xdebug_get_code_coverage();
if ($test === array()) {
  $success = TRUE;
  print "Xdebug working properly.\r\n";
  exit(0);
}

if (!$success) {
  print "Xdebug not working properly.\r\n";
  exit(1);
}
