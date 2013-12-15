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
}






function pr($a) {
	echo '<pre>';
	print_r($a);
	echo '</pre>';
}


?>
<!DOCTYPE HTML>
<html>
<head>
<title>Editor</title>

<link rel="stylesheet" href="abbott-smith.css" />
<link rel="stylesheet" href="editor.css" />
</head>
<body>
<div id="index">
<? foreach($id_list as $id => $offsets): ?>
	<a href="#<?= ($id) ?>"><?= ($id) ?></a>
<? endforeach ?>
</div>

<div id="form">
	<div class="buttons">
		<button name="prev">Prev</button>
		<button name="preview">Preview</button>	
		<button name="save">Save</button>
		<button name="savenext">Save &amp; Next</button>
		<button name="next">Next</button>
	</div>
	<div id="preview"></div>

	<input type="hidden" name="id">
	<textarea name="text"></textarea>
	<div class="buttons">
		<button name="prev">Prev</button>
		<button name="preview">Preview</button>		
		<button name="save">Save</button>
		<button name="savenext">Save &amp; Next</button>
		<button name="next">Next</button>
	</div>
</div>

<script src="jquery.min.js"></script>
<script src="editor.js"></script>
</body>
</html>
