using Gtk;

public class Ivory.Application : Gtk.Application {

	private static Ivory.Application? _instance = null;
	public static Ivory.Application instance {
		get {
			if(_instance == null) {
				_instance = new Ivory.Application();
			}
			return _instance;
		}
	}

	public Application() {
		Object(application_id: "xyz.wiedenhoeft.ivory", flags: ApplicationFlags.FLAGS_NONE);
	}

	protected override void activate() {
		var main_window = new MainWindow(this);
		main_window.show_all();
	}

	public static int main(string[] args) {
		var app = Ivory.Application.instance;
		return app.run(args);
	}
}
