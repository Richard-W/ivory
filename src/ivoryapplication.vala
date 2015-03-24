using Gtk;

/**
 * Singleton object managing the application.
 */
public class Ivory.Application : Gtk.Application {

	private static Ivory.Application? _instance = null;
	/**
	 * Only instance of this singleton object.
	 */
	public static Ivory.Application instance {
		get {
			if(_instance == null) {
				_instance = new Ivory.Application();
			}
			return _instance;
		}
	}

	private Application() {
		Object(application_id: "xyz.wiedenhoeft.ivory", flags: ApplicationFlags.FLAGS_NONE);
	}

	protected override void activate() {
		var main_window = new MainWindow(this);
		main_window.show_all();
	}
}
