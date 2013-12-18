<?php

function fix_slashes($values) {
	if (is_array($values)) {
		$values = array_map('fix_slashes', $values);
	} else {
		$values = stripslashes($values);
	}
	return $values;
}
if (php_sapi_name() != 'cli') {
	if(get_magic_quotes_gpc()) {
		$_POST    = fix_slashes($_POST);
		$_GET     = fix_slashes($_GET);
		$_REQUEST = fix_slashes($_REQUEST);
		$_COOKIE  = fix_slashes($_COOKIE);
	}
}

