using Gtk;

/**
 * Main browser window.
 */
[GtkTemplate(ui="/xyz/wiedenhoeft/ivory/ui/main_window.ui")]
public class Ivory.MainWindow : ApplicationWindow {

	[GtkChild]
	public Button back_button;
	[GtkChild]
	public Button forward_button;
	[GtkChild]
	public Entry uri_entry;
	[GtkChild]
	public Button refresh_button;
	[GtkChild]
	public Notebook notebook;
	public Tab? active_tab {
		get {
			if(notebook.get_n_pages() == 0) {
				return null;
			} else {
				return notebook.get_nth_page(notebook.page) as Tab;
			}
		}
	}


	public MainWindow(Application app) {
		Object(application: app);

		back_button.sensitive = false;
		forward_button.sensitive = false;
	}

	[GtkCallback]
	public void on_back_button_clicked(Button button) {
	}

	[GtkCallback]
	public void on_forward_button_clicked(Button button) {
	}

	[GtkCallback]
	public void on_refresh_button_clicked(Button button) {
	}

	[GtkCallback]
	public void on_newtab_button_clicked(Button button) {
		add_tab();
	}

	public void add_tab() {
		var tab = new Tab(notebook);
		notebook.append_page(tab, tab.label);
		tab.show_all();
	}

	[GtkCallback]
	public void on_uri_entry_activate(Entry entry) {
		if(active_tab == null) {
			add_tab();
		}
		active_tab.webview.load_uri(entry.text);
	}
}
