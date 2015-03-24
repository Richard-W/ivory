vala_add_executable(ivory
	ivoryapplication.vala ivorymainwindow.vala
	PACKAGES gtk+-3.0
	OPTIONS --gresources=${IVORY_RESDIR}/resources.xml
	C_SOURCES ${IVORY_BINRESDIR}/resources.c
)
set_source_files_properties(${IVORY_BINRESDIR}/resources.c PROPERTIES GENERATED 1)
add_dependencies(ivory resources)
