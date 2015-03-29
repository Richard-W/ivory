int main(string[] args) {
	var app = Ivory.Application.instance;
	app.enable_testing();
	response_queue = new AsyncQueue<bool>();

	var thread = new Thread<int>(null, () => {
		app.push_test(new CheckInitialInterface());
		if(!response_queue.pop()) return 1;
		app.push_test(new CheckWithOpenTab());
		if(!response_queue.pop()) return 1;
		app.push_test(new Quitter());
		return 0;
	});

	app.run(args);
	return thread.join();
}

AsyncQueue<bool> response_queue;

class CheckInitialInterface : Ivory.Test {
	public override void run() {
		var app = Ivory.Application.instance;
		var window = app.active_window as Ivory.MainWindow;
		if(window.back_button.sensitive || window.forward_button.sensitive) {
			message("No tab active but history button sensitive.");
			response_queue.push(false);
		} else {
			response_queue.push(true);
		}
	}
}

class CheckWithOpenTab : Ivory.Test {
	public override void run() {
		var app = Ivory.Application.instance;
		var window = app.active_window as Ivory.MainWindow;
		window.uri_entry.text = "file://" + Config.SRCDIR + "/resources/html/file1.html";
		window.uri_entry.activate();
		ulong signal_handler = 0;
		signal_handler = window.active_tab.load_changed.connect((event) => {
			if(event == WebKit.LoadEvent.FINISHED) {
				window.active_tab.disconnect(signal_handler);
				on_google_de_load_finished();
			}
		});
	}

	private void on_google_de_load_finished() {
		var app = Ivory.Application.instance;
		var window = app.active_window as Ivory.MainWindow;
		if(window.back_button.sensitive || window.forward_button.sensitive) {
			message("No history but history button sensitive");
			response_queue.push(false);
		} else {
			window.uri_entry.text = "file://" + Config.SRCDIR + "/resources/html/file2.html";
			window.uri_entry.activate();
			ulong signal_handler = 0;
			signal_handler = window.active_tab.load_changed.connect((event) => {
				if(event == WebKit.LoadEvent.FINISHED) {
					window.active_tab.disconnect(signal_handler);
					on_google_com_load_finished();
				}
			});
		}
	}

	private void on_google_com_load_finished() {
		var app = Ivory.Application.instance;
		var window = app.active_window as Ivory.MainWindow;
		if(!window.back_button.sensitive || window.forward_button.sensitive) {
			message("Expected sensitive back button and unsensitive forward button.");
			response_queue.push(false);
		} else {
			window.back_button.clicked();
			ulong signal_handler = 0;
			signal_handler = window.active_tab.load_changed.connect((event) => {
				if(event == WebKit.LoadEvent.FINISHED) {
					on_back_button_load_finished();
				}
			});
		}
	}

	private void on_back_button_load_finished() {
		var app = Ivory.Application.instance;
		var window = app.active_window as Ivory.MainWindow;
		if(window.back_button.sensitive || !window.forward_button.sensitive) {
			message("Expected sensitive forward button and unsensitive back button.");
			response_queue.push(false);
		} else {
			window.forward_button.clicked();
			ulong signal_handler = 0;
			signal_handler = window.active_tab.load_changed.connect((event) => {
				if(event == WebKit.LoadEvent.FINISHED) {
					on_forward_button_load_finished();
				}
			});
		}
	}

	private void on_forward_button_load_finished() {
		var app = Ivory.Application.instance;
		var window = app.active_window as Ivory.MainWindow;
		if(!window.back_button.sensitive || window.forward_button.sensitive) {
			message("Expected sensitive back button and unsensitive forward button.");
			response_queue.push(false);
		} else {
			response_queue.push(true);
		}
	}
}

class Quitter : Ivory.Test {
	public override void run() {
		Ivory.Application.instance.quit();
	}
}
