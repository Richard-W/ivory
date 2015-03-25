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
	/**
	 * Tab object that is currently displayed.
	 */
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
		if(active_tab != null) {
			active_tab.webview.go_back();
		}
	}

	[GtkCallback]
	public void on_forward_button_clicked(Button button) {
		if(active_tab != null) {
			active_tab.webview.go_forward();
		}
	}

	[GtkCallback]
	public void on_refresh_button_clicked(Button button) {
		if(active_tab != null) {
			active_tab.webview.reload();
		}
	}

	[GtkCallback]
	public void on_newtab_button_clicked(Button button) {
		add_tab();
	}

	private void add_tab() {
		var tab = new Tab(notebook);
		var page_num = notebook.append_page(tab, tab.label);
		tab.show();
		tab.label.show();
		notebook.set_current_page(page_num);
		uri_entry.text = "";
		uri_entry.grab_focus();
		tab.webview.load_changed.connect((event) => {
			update_buttons();
			switch(event) {
			case WebKit.LoadEvent.COMMITTED:
				update_entry();
				break;
			}
		});
	}

	private void update_buttons(Tab? _tab = null) {
		Tab tab;
		if(_tab != null) {
			tab = _tab;
		} else if(active_tab != null) {
			tab = active_tab;
		} else {
			return;
		}

		back_button.sensitive = tab.webview.can_go_back();
		forward_button.sensitive = tab.webview.can_go_forward();
	}

	private void update_entry(Tab? _tab = null) {
		Tab tab;
		if(_tab != null) {
			tab = _tab;
		} else if(active_tab != null) {
			tab = active_tab;
		} else {
			return;
		}

		uri_entry.text = tab.webview.uri;
	}

	[GtkCallback]
	public void on_uri_entry_activate(Entry entry) {
		if(active_tab == null) {
			add_tab();
		}
		active_tab.webview.load_uri(entry.text);
		active_tab.webview.grab_focus();
	}

	[GtkCallback]
	public void on_notebook_switch_page(Widget _tab, uint page_num) {
		var tab = (Tab) _tab;
		update_buttons(tab);
	}
}
