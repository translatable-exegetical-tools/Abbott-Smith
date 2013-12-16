<?php

header('Content-type: text/html; charset=utf-8;');

include "translit.php";

$src = 'abbott-smith.tei.xml';
$data = file_get_contents($src);

$offset = -1;
$matches = array();

$id_list = array();

$prev = '';

while (preg_match('#<(superEntry|entry) n="([^"]+)">#', $data, $matches, PREG_OFFSET_CAPTURE, $offset + 1)) {

	$offset = $matches[0][1];
	$key = $matches[2][0];
	$id = current(explode("|", $key));
	$tag = $matches[1][0];

	$start = $matches[0][1];

	if (preg_match("#</$tag>#", $data, $matches, PREG_OFFSET_CAPTURE, $offset + 1)) {
		$offset = $matches[0][1];
		$end = $matches[0][1] + strlen("#</$tag>");

		if (isset($id_list[$id])) {
			echo("Duplicated entry $id<br>");
		}

		$id_list[$id] = array('start' => $start, 'end' => $end);
	}

	$s_id = strip_diacritics(str_replace('_', ' ', $id));
	$s_prev = strip_diacritics(str_replace('_', ' ', $prev));

	if (strcasecmp($s_id, $s_prev) < 0) {
		echo("$id after $prev ($s_id after $s_prev)<br>");
	}

	$prev = $id;
}

function pr($a) {
	echo '<pre>';
	print_r($a);
	echo '</pre>';
}
