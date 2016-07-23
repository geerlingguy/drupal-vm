<?php

/**
 * @file
 * Test if Redis is available and working.
 */

$success = FALSE;
$key = 'test';
$value = 'Success';

if (class_exists('Redis')) {
  $redis = new Redis;
  $redis->connect('127.0.0.1', 6379);

  // Test adding a value to redis.
  if ($redis->set($key, $value)) {
    $result = $redis->get($key);

    // If we get the expected result, it was a success.
    if ($result == $value) {
      $success = TRUE;
      print "Redis connection successful.\r\n";
      exit(0);
    }
  }
}

if (!$success) {
  print "Redis not working properly.\r\n";
  exit(1);
}
