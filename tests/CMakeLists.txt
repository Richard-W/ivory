function(ivory_test test)
	include_directories(${IVORY_BINDIR})
	include_directories(${IVORY_BINDIR}/src)

	vala_add_executable(${test}
			${test}.vala
		C_SOURCES ${IVORY_BINRESDIR}/resources.c
		CUSTOM_VAPIS
			${IVORY_SRCDIR}/config.vapi
			${IVORY_BINDIR}/src/ivory.vapi
		PACKAGES ${ivory_vala_packages}
		OPTIONS ${ivory_vala_options}
	)
	target_link_libraries(${test} ivory_static)

	add_test(NAME ${test} COMMAND ${test})
endfunction()
