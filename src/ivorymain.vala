/**
 * Main method starting the application.
 *
 * This is the only function that is not part of the static library
 * used for testing.
 */
int main(string[] args) {
	var app = Ivory.Application.instance;
	return app.run(args);
}
