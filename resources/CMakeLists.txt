find_program (RESOURCES_COMPILER NAMES glib-compile-resources)

add_custom_command(
	OUTPUT resources.c
	COMMAND  ${RESOURCES_COMPILER}
		${IVORY_RESDIR}/resources.xml
		--sourcedir=${IVORY_RESDIR}
		--target=${IVORY_BINRESDIR}/resources.c
		--generate-source
	MAIN_DEPENDENCY resources.xml
	DEPENDS ${IVORY_RESDIR}/ui/main_window.ui
)

add_custom_target(resources DEPENDS resources.c)
