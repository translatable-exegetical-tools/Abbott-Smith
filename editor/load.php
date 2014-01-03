<?php

header('Content-type: application/json;');
require_once 'fix_magic_quotes.php';

$src = '../abbott-smith.tei.xml';
$data = file_get_contents($src);

$search = $_GET['id'];

$offset = -1;
$matches = array();

$found = false;


while (preg_match('#<(superEntry|entry) n="([^"]+)">#', $data, $matches, PREG_OFFSET_CAPTURE, $offset + 1)) {

	$offset = $matches[0][1];
	$key = $matches[2][0];
	$id = current(explode("|", $key));
	$tag = $matches[1][0];

	$start = $matches[0][1];

	if (preg_match("#</$tag>#", $data, $matches, PREG_OFFSET_CAPTURE, $offset + 1)) {
		$offset = $matches[0][1];
		$end = $matches[0][1] + strlen("</$tag>");

		if ($id == $search) {
			$len = $end - $start;
			$found = substr($data, $start, $len);
			break;
		}
	}
}


echo json_encode(array(
	'found' => $found
));


