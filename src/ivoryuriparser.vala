public class Ivory.URIParser {

	Regex containsProtocol;
	Regex mightBeURI;

	public string search_engine_prefix { get; set; default = "https://www.google.de/search?q="; }

	public URIParser() {
		try {
			containsProtocol = new Regex("[a-zA-Z0-9]+://.*");
			mightBeURI = new Regex("[^ ]+?\\.[^ ]+");
		} catch(Error e) {
			assert_not_reached();
		}
	}

	/** Takes a text and returns an uri */
	public string parse(string text) {
		if(containsProtocol.match(text)) {
			return text;
		} else if(mightBeURI.match(text)) {
			return "http://" + text;
		} else {
			return search_engine_prefix + GLib.Uri.escape_string(text);
		}
	}
}
