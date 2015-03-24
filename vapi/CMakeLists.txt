find_program(VAPIGEN_EXECUTABLE NAMES vapigen)

add_custom_command(
	OUTPUT webkit2gtk-4.0.vapi
	COMMAND
		${VAPIGEN_EXECUTABLE}
	        --pkg gio-2.0
		--pkg gtk+-3.0
		--pkg libsoup-2.4
		--library=webkit2gtk-4.0
		--directory=${CMAKE_CURRENT_BINARY_DIR}
		`pkg-config --variable=girdir gobject-introspection-1.0`/WebKit2-4.0.gir
)
add_custom_target(vapis DEPENDS webkit2gtk-4.0.vapi)
