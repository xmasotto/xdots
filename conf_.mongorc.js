shellHelper["sd"] = function() { shellHelper["show"]("dbs") }
shellHelper["sc"] = function() { shellHelper["show"]("collections") }

function funcs(o, prefix) {
    if (prefix == null) prefix = ""
    for (var k in o) {
	if (typeof(o[k]) == "function") {
	    s = o[k].toString()
	    print(prefix + k + s.substring(s.indexOf("("), s.indexOf("{")));
	}
    }
}

function vars(o, prefix) {
    if (prefix == null) prefix = ""
    for (var k in o) {
	if (typeof(o[k]) == "object") {
	    print(prefix + k + ": {");
	    vars(o[k], prefix + "  ");
	    print(prefix + "}");
	} else if (typeof(o[k]) != "function") {
	    print(prefix + k);
	}
    }
}
