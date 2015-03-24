# Compile the entire code into a static library so it can be linked against tests.
# For some reason resources.c can not be included here.
vala_add_library(ivory_static STATIC
		ivoryapplication.vala
		ivorymainwindow.vala
	PACKAGES gtk+-3.0
	OPTIONS --gresources=${IVORY_RESDIR}/resources.xml
	GENERATE_VAPI
	LIBRARY_NAME ivory_static
	VAPI_PATH_VARIABLE ivory_static_vapi
	NO_LINKING
)

# Compile the actual executable and link it with the previously compiled static library.
vala_add_executable(ivory
		ivorymain.vala
	PACKAGES gtk+-3.0
	CUSTOM_VAPIS ${ivory_static_vapi}
	C_SOURCES ${IVORY_BINRESDIR}/resources.c
)
set_source_files_properties(${IVORY_BINRESDIR}/resources.c PROPERTIES GENERATED 1)
add_dependencies(ivory resources)
target_link_libraries(ivory ivory_static)
