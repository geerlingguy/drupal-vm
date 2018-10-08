<?php

/**
 * @file
 * Test if Memcached is available and working.
 *
 * Note that if you run this script more than once per second, the add() call
 * will fail. Why would you run this more than once per second?!
 */

$success = FALSE;
$key = 'test';
$value = 'Success';

if (class_exists('Memcached')) {
  $memcached = new Memcached;
  $memcached->addServer('127.0.0.1', 11211);

  // Test adding a value to memcached.
  if ($memcached->add($key, $value, 1)) {
    $result = $memcached->get($key);

    // If we get the expected result, it was a success.
    if ($result == $value) {
      $success = TRUE;
      print "Memcached connection successful.\r\n";
      exit(0);
    }
  }
}

if (!$success) {
  print "Memcached not working properly.\r\n";
  exit(1);
}
