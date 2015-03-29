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
			active_tab.go_back();
		}
	}

	[GtkCallback]
	public void on_forward_button_clicked(Button button) {
		if(active_tab != null) {
			active_tab.go_forward();
		}
	}

	[GtkCallback]
	public void on_refresh_button_clicked(Button button) {
		if(active_tab != null) {
			active_tab.reload();
		}
	}

	[GtkCallback]
	public void on_newtab_button_clicked(Button button) {
		add_tab();
	}

	private Tab add_tab(string uri = "") {
		var tab = new Tab(notebook);
		uri_entry.text = uri;
		uri_entry.grab_focus();
		tab.load_changed.connect((event) => {
			update_buttons();
			switch(event) {
			case WebKit.LoadEvent.COMMITTED:
				update_entry();
				break;
			}
		});
		tab.load_uri(uri);
		tab.show();
		notebook.set_current_page(tab.page_num);
		return tab;
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

		back_button.sensitive = tab.can_go_back;
		forward_button.sensitive = tab.can_go_forward;
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

		if(tab.uri != null) {
			uri_entry.text = tab.uri;
		}
	}

	[GtkCallback]
	public void on_uri_entry_activate(Entry entry) {
		Tab tab;
		if(active_tab != null) {
			tab = active_tab;
			tab.load_uri(entry.text);
		} else {
			tab = add_tab(entry.text);
		}
		tab.grab_focus();
	}

	[GtkCallback]
	public void on_notebook_switch_page(Widget _tab, uint page_num) {
		var tab = (Tab) _tab;
		update_buttons(tab);
		update_entry(tab);
	}
}
