<?php

/**
 * @file
 * Test if Tideways is available and working.
 */

$tideways_root_dir = '/usr/share/php';
$xhprof_root_dir = '/usr/share/php';
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

$output_dir = sys_get_temp_dir();
$xhprof_runs = new XHProfRuns_Default($output_dir);
$run_id = $xhprof_runs->save_run($data, 'xhprof_testing');
$filename = "$output_dir/$run_id.xhprof_testing.xhprof";
if (file_exists($filename)) {
  print "XHProf PHP library writing to output directory.\r\n";
}
else {
  print "XHProf PHP library not working.\r\n";
  $success = FALSE;
}
ob_start();
include $xhprof_root_dir . '/xhprof_html/index.php';
$html = ob_get_clean();
if (strpos($html, "?run=$run_id") !== FALSE) {
  print "XHProf UI working.\r\n";
}
else {
  print "XHProf UI not working.\r\n";
  $success = FALSE;
}

if (!$success) {
  exit(1);
}
