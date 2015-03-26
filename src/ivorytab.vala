using Gtk;

/**
 * Widget that actually displays websites.
 *
 * Instances of this object are added to the notebook in
 * the main window.
 */
public class Ivory.Tab : Box {

	private TabLabel label;
	private WebKit.WebView web_view;
	private Notebook notebook;

	/**
	 * Position in the notebook given during construction.
	 */
	public int page_num { get { return notebook.page_num(this); } }

	/**
	 * Content of the displayed websites title tag.
	 */
	public string title { get { return web_view.title; } }

	/**
	 * URI of the displayed website.
	 */
	public string uri { get { return web_view.uri; } }

	/**
	 * Whether the web view can go back.
	 */
	public bool can_go_back { get { return web_view.can_go_back(); } }

	/**
	 * Whether the web view can go forward.
	 */
	public bool can_go_forward { get { return web_view.can_go_forward(); } }

	/**
	 * Favicon of the displayed website
	 */
	public unowned Cairo.Surface favicon { get { return web_view.get_favicon(); } }

	/**
	 * Emitted when the loading state of the website changes.
	 */
	public signal void load_changed(WebKit.LoadEvent event);
	
	/**
	 * Takes a notebook to manage its own removal.
	 */
	public Tab(Notebook notebook) {
		this.notebook = notebook;
		this.web_view = new WebKit.WebView.with_settings(WebSettings.instance);

		pack_start(web_view);
		web_view.notify.connect(on_web_view_notify);
		web_view.load_changed.connect((event) => { load_changed(event); });
		web_view.create.connect(on_web_view_create);

		label =  new TabLabel(this);
		label.close_button.clicked.connect(() => {
			notebook.remove_page(page_num);
		});

		notebook.append_page(this, label);
	}

	public override void show() {
		base.show();
		web_view.show();
		label.show();
	}

	private void on_web_view_notify(ParamSpec pspec) {
		switch(pspec.name) {
		case "title":
			notify_property("title");
			break;
		case "uri":
			notify_property("uri");
			break;
		case "favicon":
			notify_property("favicon");
			break;
		}
	}

	private Widget on_web_view_create(WebKit.NavigationAction nav_action) {
		var tab = new Tab(this.notebook);
		tab.web_view.ready_to_show.connect(() => {
			tab.show();
		});
		return tab.web_view;
	}

	public void load_uri(string uri) {
		web_view.load_uri(uri);
	}

	public override void grab_focus() {
		web_view.grab_focus();
	}

	public void go_back() {
		web_view.go_back();
	}

	public void go_forward() {
		web_view.go_forward();
	}

	public void reload() {
		web_view.reload();
	}
}

