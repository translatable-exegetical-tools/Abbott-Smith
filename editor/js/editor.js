var xsl = null;
var xsltProcessor = new XSLTProcessor();
var parser = new DOMParser();

$.get('edit.xsl', function(response) {
	xsl = response;
	xsltProcessor.importStylesheet(xsl);
	onLoad();
});


$("#index a").not('.page-sep').click(function(evt) {
	var key = $(this).attr('href').substr(1);
	if (!loadKey(key)) {
		return;
	}
	$("#index .current").removeClass("current");
	$(this).addClass("current");
	top.location.hash = "#" + key;

	var page = $(this).attr('data-page');
	//$('a.view-page').attr('href', "http://archive.org/stream/manualgreeklexic00abborich#page/"+page+"/mode/1up");
	$('a.view-page').attr('href', "http://heml.mta.ca/lace/sidebysideview2/"+(parseInt(page) + 10970913));
	$('a.view-page .page').html(page);


	$(this).get(0).scrollIntoView();
});

function onLoad() {
	if (window.location.hash.length) {
		var key = window.location.hash.substr(1);
		$('#index a[href=#'+key+']').click();
	}
}

$(window).on('hashchange', function(evt) {
	var key = window.location.hash.substr(1);
	var link = $('#index a[href=#'+key+']').not('.current').click();
});

$('#form button').click(function(evt) {
	var action = $(this).attr('name');
	switch(action) {
		case 'next': $('#index .current').nextAll(':not(.page-sep):eq(0)').click(); break;
		case 'prev': $('#index .current').prevAll(':not(.page-sep):eq(0)').click(); break;
		case 'preview': preview(); break;
		case 'save': save(false); preview(); break;
		case 'savenext': save(true); break;
		case 'replace': editor_replace($(this).attr('data-text')); preview(); break;

		default: break;
	}
});

function save(next) {
	var text = $('#form textarea[name=text]').val();
	var id = $('#form input[name=id]').val();

	if (typeof(editor) != 'undefined') {
		text = editor.getValue();
	}

	$.post("save.php", {id: id, text: text}, function(response) {
		if (!response.saved) {
			alert("Entry '" + id + "' not found.");
			return;
		}
		if (typeof(editor) != 'undefined') {
			editor.markClean();
		}
		if (next) {
			$('#index .current').next('a').click();
		}
	});
}

function preview() {
	var xml = $('#form textarea[name=text]').val();
	if (typeof(editor) != 'undefined') {
		xml = editor.getValue();
	}

	var fragment = parser.parseFromString('<TEI xmlns="http://www.crosswire.org/2008/TEIOSIS/namespace" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.crosswire.org/2008/TEIOSIS/namespace http://www.crosswire.org/OSIS/teiP5osis.1.4.xsd">' + xml + '</TEI>', "application/xml");

	var resultDocument = xsltProcessor.transformToFragment(fragment, document);
	$("#preview").html(resultDocument);
}


function loadKey(key) {
	if (typeof(editor) != 'undefined' && !editor.isClean()) {
		if (!confirm("Changes not saved, discard changes?")) {
			return false;
		}
	}

	$.get('load.php', {id: key}, function(response) {
		if (!response.found) {
			alert("Entry '" + key + "' not found.");
			return;
		}

		$('#form input[name=id]').val(key);
		$('#form textarea[name=text]').val(response.found);

		if (typeof(editor) != 'undefined') {
			editor.setValue(response.found);
			editor.markClean();
		}

		preview();
	});
	return true;
}

function getSelectedText() {
	if (window.getSelection) {
		return window.getSelection().toString();
	} else if (document.selection) {
		return document.selection.createRange().text;
	}
	return '';
}

function getSelectionRange() {
	if (window.getSelection) {
		return window.getSelection().getRangeAt(0);
	} else if (document.selection) {
		return document.selection.getRangeAt(0);
	}
}


function escapeRegExp(str) {
	return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
}

$('#preview').mouseup(function(evt) {
	sel_text = getSelectedText();
	if (!sel_text.length) {
		return;
	}
	var rx = new RegExp("<([a-z]+)[^>]*>[ ]*"+escapeRegExp(sel_text)+"[ ]*</\\1>|[^\"]"+escapeRegExp(sel_text), 'g');
	var found = [];

	var line = 0;
	editor.eachLine(function(l) {
		var all_matches = l.text.match(rx);
		if (all_matches) {
			var offset = 0;
			for (var i = 0; i < all_matches.length ; i++) {
				var matches = all_matches[i].substring(0, 1) == '<' ? all_matches[i] : all_matches[i].substring(1);

				var pos = l.text.indexOf(matches, offset);
				var end = pos + matches.length;
				offset = end;
				found.push({line: line, start: pos, end: end, text: matches});
			}

		}
		++line;
	});

	if (found.length == 1) {
		var sel = found[0];
		editor.setSelection({line: sel.line, ch: sel.start}, {line: sel.line, ch: sel.end});
		return;
	}

	var range = getSelectionRange();
	range.setEnd(range.startContainer, range.startOffset);
	range.setStart(document.getElementById('preview'), 0);

	var skip = range.toString().match(rx);
	var idx = skip ? skip.length : 0;
	if (found[idx]) {
		var sel = found[idx];
		editor.setSelection({line: sel.line, ch: sel.start}, {line: sel.line, ch: sel.end});
	}
});

