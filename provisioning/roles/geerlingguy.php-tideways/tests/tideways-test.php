<?php

/**
 * @file
 * Test if Tideways is available and working.
 */

$tideways_root_dir = '/usr/share/php';
$success = TRUE;

tideways_enable();
$data = tideways_disable();

if (isset($data['main()==>tideways_disable'])) {
  print "Tideways profiling working.\r\n";
}
else {
  print "Tideways profiling not working.\r\n";
  $success = FALSE;
}

include $xhprof_root_dir . '/xhprof_lib/utils/xhprof_lib.php';
include $xhprof_root_dir . '/xhprof_lib/utils/xhprof_runs.php';

if (!$success) {
  exit(1);
}
