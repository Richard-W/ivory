# Compile the entire code into a static library so it can be linked against tests.
# For some reason resources.c can not be included here.
vala_add_library(ivory_static STATIC
		ivoryapplication.vala
		ivorymainwindow.vala
		ivorytab.vala
		ivorytablabel.vala
		ivorywebsettings.vala
		ivoryuriparser.vala
	PACKAGES ${ivory_vala_packages}
	OPTIONS ${ivory_vala_options}
	GENERATE_VAPI
	LIBRARY_NAME ivory
	VAPI_PATH_VARIABLE ivory_vapi
	NO_LINKING
)

# Compile the actual executable and link it with the previously compiled static library.
vala_add_executable(ivory
		ivorymain.vala
	PACKAGES ${ivory_vala_packages}
	OPTIONS ${ivory_vala_options}
	CUSTOM_VAPIS ${ivory_vapi}
	C_SOURCES ${IVORY_BINRESDIR}/resources.c
)
set_source_files_properties(${IVORY_BINRESDIR}/resources.c PROPERTIES GENERATED 1)
add_dependencies(ivory resources)
target_link_libraries(ivory ivory_static)
