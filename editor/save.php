<?php

header('Content-type: application/json;');

$src = '../abbott-smith.tei.xml';
$data = file_get_contents($src);

$offset = -1;
$matches = array();

$found = false;
$search = $_POST['id'];
$replace = $_POST['text'];

while (preg_match('#<(superEntry|entry) n="([^"]+)">#', $data, $matches, PREG_OFFSET_CAPTURE, $offset + 1)) {

	$offset = $matches[0][1];
	$key = $matches[2][0];
	$id = current(explode("|", $key));
	$tag = $matches[1][0];

	$start = $matches[0][1];

	if (preg_match("#</$tag>#", $data, $matches, PREG_OFFSET_CAPTURE, $offset + 1)) {
		$offset = $matches[0][1];
		$end = $matches[0][1] + strlen("#</$tag>");

		if ($id == $search) {
			$len = $end - $start;
			$data = substr_replace($data, $replace, $start, $len);
			$found = true;
			break;
		}
	}
}

if ($found) {
	file_put_contents($src, $data);
}

echo json_encode(array(
	'saved' => $found,
	'id' => $search
));


