<?php

header('Content-type: text/html; charset=utf-8;');
require_once 'fix_magic_quotes.php';

$src = '../abbott-smith.tei.xml';
$data = file_get_contents($src);

$offset = -1;
$matches = array();

$id_list = array();

$prev = '';

$page = 1;
$start = 0;
$end = 0;

while (preg_match('#<(superEntry|entry) n="([^"]+)">#', $data, $matches, PREG_OFFSET_CAPTURE, $offset + 1)) {

	$offset = $matches[0][1];
	$key = $matches[2][0];
	$id = current(explode("|", $key));
	$tag = $matches[1][0];

	$start = $matches[0][1];

	if ($end) {
		$len = $start - $end;
		$between = substr($data, $end, $len);
		if (preg_match('#<pb n="([0-9]+)"#', $between, $matches)) {
			$page = $matches[1];
		}
	}

	if (preg_match("#</$tag>#", $data, $matches, PREG_OFFSET_CAPTURE, $offset + 1)) {
		$offset = $matches[0][1];
		$end = $matches[0][1] + strlen("</$tag>");
		$id_list[$id] = array('start' => $start, 'end' => $end, 'page' => $page);

		$len = $end - $start;
		$entry = substr($data, $start, $len);
		if (preg_match('#<pb n="([0-9]+)"#', $entry, $matches)) {
			$page = $matches[1];
		}

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

<link rel="stylesheet" href="css/abbott-smith.css">
<link rel="stylesheet" href="css/editor.css">
<link rel="stylesheet" href="js/lib/codemirror.css">
<link rel="stylesheet" href="js/lib/hint/show-hint.css">
</head>
<body>
<div id="index">
<?php
$page = 0;
foreach($id_list as $id => $offsets): ?>
	<?php if ($offsets['page'] != $page): $page = $offsets['page']; ?>
	<a class="page-sep" target="_blank" href="<?php echo "http://heml.mta.ca/lace/sidebysideview2/" . ($offsets['page'] + 10970913); ?>">-Page <?php echo $offsets['page']; ?>-</a>
	<?php endif; ?>
	<a href="#<?php echo ($id); ?>" data-page="<?php echo $offsets['page']; ?>"><?php echo ($id); ?></a>
<?php endforeach; ?>
</div>

<div id="form">
	<div id="preview"></div>

	<div class="buttons">
		<button name="prev">Prev</button>
		<button name="preview">Preview</button>		
		<button name="save">Save</button>
		<button name="savenext">Save &amp; Next</button>
		<button name="next">Next</button>
		<label><input type="checkbox" name="wrap" value="1" checked="checked"> Line Wrap</label>
	</div>

	<div class="buttons">
		<button name="replace" data-text="gloss">gloss</button>
		<button name="replace" data-text="emph">emph</button>
		<button name="replace" data-text="grc">grc</button>
		<button name="replace" data-text="heb">heb</button>
		<button name="replace" data-text="sense">sense</button>
		<button name="replace" data-text="orth">orth</button>
		<button name="replace" data-text="entry">entry</button>
		<a class="view-page" href="#" target="_blank">View Page (<span class="page"></span>)</a>
	</div>

	<input type="hidden" name="id">
	<textarea name="text" id="code"></textarea>
</div>

<script src="js/lib/jquery.min.js"></script>
<script src="js/lib/codemirror.js"></script>
<script src="js/lib/mode/xml/xml.js"></script>
<script src="js/lib/hint/show-hint.js"></script>
<script src="js/lib/hint/xml-hint.js"></script>
<script src="js/autocomplete.js"></script>
<script src="js/editor.js"></script>
</body>
</html>
