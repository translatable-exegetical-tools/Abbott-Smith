var tags = {
    "!top": ["entry", "superEntry"],
	entry: {
		attrs: {
			n: null,
		},
		children: ["form", "etym", "gramGrp", "sense", "re", "note"]
	},
	gramGrp: {
		children: ["pos"]
	},
    form: {
		children: ["orth", "foreign"]
	},
	sense: {
		children: ["sense", "foreign", "gloss", "emph", "hi", "xr", "ref"]
	},
	foreign: {
		attrs: {
			"xml:lang": ["grc", "heb", "arc", "lat"]
		}
	},
	note: {
		attrs: {
			type: null
		}
	},
	ref: {
		attrs: {
			osisRef: null,
			target: null
		}
	},
};

function completeAfter(cm, pred) {
	var cur = cm.getCursor();
	if (!pred || pred()) {
		setTimeout(function() {
			if (!cm.state.completionActive) {
				CodeMirror.showHint(cm, CodeMirror.hint.xml, {schemaInfo: tags, completeSingle: false});
				}
		}, 100);
	}
	return CodeMirror.Pass;
}

function completeIfAfterLt(cm) {
	return completeAfter(cm, function() {
		var cur = cm.getCursor();
		return cm.getRange(CodeMirror.Pos(cur.line, cur.ch - 1), cur) == "<";
	});
}

function completeIfInTag(cm) {
	return completeAfter(cm, function() {
		var tok = cm.getTokenAt(cm.getCursor());
		if (tok.type == "string" && (!/['"]/.test(tok.string.charAt(tok.string.length - 1)) || tok.string.length == 1)) {
			return false;
		}
		var inner = CodeMirror.innerMode(cm.getMode(), tok.state).state;
		return inner.tagName;
	});
}

var editor = CodeMirror.fromTextArea(document.getElementById("code"), {
	mode: "text/html",
	lineNumbers: true,
	extraKeys: {
		"'<'": completeAfter,
		"'/'": completeIfAfterLt,
		"' '": completeIfInTag,
		"'='": completeIfInTag,
		"Ctrl-Space": function(cm) {
			CodeMirror.showHint(cm, CodeMirror.hint.xml, {schemaInfo: tags});
		}
	}
});

