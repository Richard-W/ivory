class Ivory.WebSettings : WebKit.Settings {

	private static WebSettings? _instance = null;
	public static WebSettings instance { get {
		if(_instance == null) _instance = new WebSettings();
		return _instance;
	}}

	private WebSettings() {
		enable_accelerated_2d_canvas = true;
		enable_developer_extras = true;
		enable_java = false;
		enable_javascript = true;
		enable_webaudio = true;
		enable_webgl = true;
	}
}
