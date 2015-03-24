using Gtk;

/**
 * Widget that actually displays websites.
 *
 * Instances of this object are added to the notebook in
 * the main window. A widget for the tab label is also
 * provided.
 */
public class Ivory.Tab : Box {

	public TabLabel label = new TabLabel();
	public WebKit.WebView webview = new WebKit.WebView();
	public Notebook notebook;
	
	/**
	 * Takes a notebook to manage its own removal.
	 */
	public Tab(Notebook notebook) {
		this.pack_start(webview);
		label.show_all();
		this.notebook = notebook;

		label.close_button.clicked.connect(() => {
			notebook.remove_page(notebook.page_num(this));
		});
	}
}

[GtkTemplate(ui="/xyz/wiedenhoeft/ivory/ui/tab.ui")]
public class Ivory.TabLabel : Box {
	
	[GtkChild]
	public Image favicon;
	[GtkChild]
	public Label label;
	[GtkChild]
	public Button close_button;
}
