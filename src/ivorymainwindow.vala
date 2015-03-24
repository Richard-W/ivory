using Gtk;

[GtkTemplate(ui="/xyz/wiedenhoeft/ivory/ui/main_window.ui")]
class Ivory.MainWindow : ApplicationWindow {

	public MainWindow(Application app) {
		Object(application: app);
	}
}
