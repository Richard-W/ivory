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

	private AsyncQueue<Test>? testing_queue = null;

	/**
	 * Enable testing mode.
	 *
	 * This enables the testing mode and makes it possible to push Test objects
	 * into the main loop. In testing mode the main loop will check the testing_queue
	 * for new Test objects and executes them.
	 */
	public void enable_testing() {
		testing_queue = new AsyncQueue<Test>();
		Timeout.add_full(Priority.DEFAULT, 50, () => {
			Test? test = testing_queue.try_pop();
			if(test != null) {
				test.run();
			}
			return true;
		});
		message("Testing enabled.");
	}

	/**
	 * Adds a test to the main application loop.
	 */
	public void push_test(Test test) {
		if(testing_queue != null) {
			testing_queue.push(test);
		} else {
			error("Test pushed but testing not enabled.");
		}
	}

	protected override void startup() {
		base.startup();
		var confdir = Environment.get_home_dir() + "/.ivory";
		var context = WebKit.WebContext.get_default();

		// Set favicon database directory
		context.set_favicon_database_directory(
			confdir + "/favicons"
		);

		var cookie_manager = context.get_cookie_manager();
		cookie_manager.set_persistent_storage(confdir + "/cookie_jar.sqlite", WebKit.CookiePersistentStorage.SQLITE);
	}

	protected override void activate() {
		var main_window = new MainWindow(this);
		main_window.show_all();
	}
}

/**
 * A test that can be pushed to the main application loop.
 */
public abstract class Ivory.Test {
	public abstract void run();
}
