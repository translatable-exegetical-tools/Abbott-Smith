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
	loadKey(key);
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
	$.get('load.php', {id: key}, function(response) {
		if (!response.found) {
			alert("Entry '" + key + "' not found.");
			return;
		}

		$('#form input[name=id]').val(key);
		$('#form textarea[name=text]').val(response.found);

		if (typeof(editor) != 'undefined') {
			editor.setValue(response.found);
		}

		preview();
	})
}



