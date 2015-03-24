# Copyright (c) 2014, Richard Wiedenhöft <richard@wiedenhoeft.xyz>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

include (CMakeParseArguments)

function (vala_precompile)
	cmake_parse_arguments (
		ARGS
		"GENERATE_VAPI;GENERATE_INTERNAL_VAPI"
		"VAPI_PATH_VARIABLE;HEADER_PATH_VARIABLE;INTERNAL_VAPI_PATH_VARIABLE;INTERNAL_HEADER_PATH_VARIABLE;C_SOURCES_VARIABLE;LIBRARY_NAME"
		"SOURCES;PACKAGES;OPTIONS;CUSTOM_VAPIS"
		${ARGN}
	)

	# Without output this command would be pretty much useless.
	if (NOT ARGS_C_SOURCES_VARIABLE)
		message (FATAL_ERROR "C_SOURCES_VARIABLE not set in vala_precompile.")
	endif ()

	# Initialize valac_args.
	unset (valac_args)

	list (APPEND valac_args "--ccode")

	# Set library name
	if (ARGS_LIBRARY_NAME)
		list (APPEND valac_args "--library=${ARGS_LIBRARY_NAME}")
	endif ()

	# Should vapi be generated?
	if (ARGS_GENERATE_VAPI)
		if (NOT ARGS_LIBRARY_NAME)
			message (FATAL_ERROR "You can not create a vapi without setting LIBRARY_NAME.")
		endif ()

		set (vapi_name "${ARGS_LIBRARY_NAME}.vapi")
		set (header_name "${ARGS_LIBRARY_NAME}.h")
		set (vapi_path "${CMAKE_CURRENT_BINARY_DIR}/${vapi_name}")
		set (header_path "${CMAKE_CURRENT_BINARY_DIR}/${header_name}")

		list (APPEND valac_args "--vapi=${vapi_name}")
		list (APPEND valac_args "--header=${header_name}")

		set (${ARGS_VAPI_PATH_VARIABLE} ${vapi_path} PARENT_SCOPE)
		set (${ARGS_HEADER_PATH_VARIABLE} ${header_path} PARENT_SCOPE)
	endif ()

	# Should internal vapi be generated?
	if (ARGS_GENERATE_INTERNAL_VAPI)
		if (NOT ARGS_LIBRARY_NAME)
			message (FATAL_ERROR "You can not create an internal vapi without setting LIBRARY_NAME.")
		endif ()

		set (internal_vapi_name "${ARGS_LIBRARY_NAME}_internal.vapi")
		set (internal_header_name "${ARGS_LIBRARY_NAME}_internal.h")
		set (internal_vapi_path "${CMAKE_CURRENT_BINARY_DIR}/${internal_vapi_name}")
		set (internal_header_path "${CMAKE_CURRENT_BINARY_DIR}/${internal_header_name}")

		list (APPEND valac_args "--internal-vapi=${internal_vapi_name}")
		list (APPEND valac_args "--internal-header=${internal_header_name}")

		set (${ARGS_INTERNAL_VAPI_PATH_VARIABLE} ${internal_vapi_path} PARENT_SCOPE)
		set (${ARGS_INTERNAL_HEADER_PATH_VARIABLE} ${internal_header_path} PARENT_SCOPE)
	endif ()

	# Add package options
	foreach (package ${ARGS_PACKAGES})
		list (APPEND valac_args "--pkg=${package}")
	endforeach ()

	# Add custom options
	foreach (option ${ARGS_OPTIONS})
		list (APPEND valac_args ${option})
	endforeach ()

	# Add custom vapis (absolute path given)
	foreach (custom_vapi ${ARGS_CUSTOM_VAPIS})
		list (APPEND valac_args "${custom_vapi}")
	endforeach ()

	# Initialize c_output
	set (c_output_files "")
	set (vala_input_files "")

	# Add sources (relative path given)
	foreach (source ${ARGS_SOURCES})
		set (vala_input_file "${CMAKE_CURRENT_SOURCE_DIR}/${source}")
		list (APPEND vala_input_files "${vala_input_file}")

		string (REGEX REPLACE "vala$" "c" c_output_file ${source})
		list (APPEND c_output_files "${CMAKE_CURRENT_BINARY_DIR}/${c_output_file}")

		list (APPEND valac_args "${vala_input_file}")
	endforeach ()

	# Set target glib
	list (APPEND valac_args "--target-glib=${GLIB_VERSION}")

	# Add rule to create the output files
	add_custom_command (
		OUTPUT
			${c_output_files}
			${vapi_path}
			${internal_vapi_path}
			${header_path}
			${internal_header_path}
		COMMAND
			${VALA_EXECUTABLE}
		ARGS
			${valac_args}
		DEPENDS
			${vala_input_files}
			${ARGS_CUSTOM_VAPIS}
	)

	set (${ARGS_C_SOURCES_VARIABLE} "${c_output_files}" PARENT_SCOPE)
endfunction (vala_precompile)

function (vala_add_executable name)
	cmake_parse_arguments (
		ARGS
		""
		""
		"PACKAGES;OPTIONS;CUSTOM_VAPIS;C_SOURCES"
		${ARGN}
	)

	vala_precompile (
		SOURCES ${ARGS_UNPARSED_ARGUMENTS}
		PACKAGES ${ARGS_PACKAGES}
		OPTIONS ${ARGS_OPTIONS}
		CUSTOM_VAPIS ${ARGS_CUSTOM_VAPIS}
		C_SOURCES_VARIABLE c_sources
	)

	include_directories (${VALA_INCLUDE_DIRS})
	link_directories (${VALA_LIBRARY_DIRS})

	unset (local_libraries)
	foreach (package ${ARGS_PACKAGES})
		pkg_check_modules (
			PACKAGE
			${package}
			REQUIRED
		)
		include_directories (${PACKAGE_INCLUDE_DIRS})
		link_directories (${PACKAGE_LIBRARY_DIRS})
		foreach (local_library ${PACKAGE_LIBRARIES})
			list (APPEND local_libraries ${local_library})
		endforeach ()
	endforeach ()
	
	add_executable (${name} ${c_sources} ${ARGS_C_SOURCES})
	target_link_libraries (${name}
		${local_libraries}
		${VALA_LIBRARIES}
	)
endfunction ()	

function (vala_add_library name type)
	cmake_parse_arguments (
		ARGS
		"GENERATE_VAPI;GENERATE_INTERNAL_VAPI"
		"VAPI_PATH_VARIABLE;HEADER_PATH_VARIABLE;INTERNAL_VAPI_PATH_VARIABLE;INTERNAL_HEADER_PATH_VARIABLE;LIBRARY_NAME"
		"PACKAGES;OPTIONS;CUSTOM_VAPIS;C_SOURCES"
		${ARGN}
	)

	unset (precompile_options)
	if (ARGS_GENERATE_VAPI)
		set (precompile_options GENERATE_VAPI)
	endif ()
	if (ARGS_GENERATE_INTERNAL_VAPI)
		set (precompile_options ${precompile_options} GENERATE_INTERNAL_VAPI)
	endif ()

	if (NOT type MATCHES "^(STATIC|SHARED|MODULE|OBJECT)$")
		list (INSERT ARGS_UNPARSED_ARGUMENTS 0 "${type}")
		unset (type)
	endif ()

	vala_precompile (
		SOURCES ${ARGS_UNPARSED_ARGUMENTS}
		PACKAGES ${ARGS_PACKAGES}
		OPTIONS ${ARGS_OPTIONS}
		CUSTOM_VAPIS ${ARGS_CUSTOM_VAPIS}
		${precompile_options}
		VAPI_PATH_VARIABLE vapi_path
		HEADER_PATH_VARIABLE header_path
		INTERNAL_VAPI_PATH_VARIABLE internal_vapi_path
		INTERNAL_HEADER_PATH_VARIABLE internal_header_path
		LIBRARY_NAME ${ARGS_LIBRARY_NAME}
		C_SOURCES_VARIABLE c_sources
	)

	set (${ARGS_VAPI_PATH_VARIABLE} ${vapi_path} PARENT_SCOPE)
	set (${ARGS_HEADER_PATH_VARIABLE} ${header_path} PARENT_SCOPE)
	set (${ARGS_INTERNAL_VAPI_PATH_VARIABLE} ${internal_vapi_path} PARENT_SCOPE)
	set (${ARGS_INTERNAL_HEADER_PATH_VARIABLE} ${internal_header_path} PARENT_SCOPE)

	include_directories (${VALA_INCLUDE_DIRS})
	link_directories (${VALA_LIBRARY_DIRS})

	unset (local_libraries)
	foreach (package ${ARGS_PACKAGES})
		pkg_check_modules (
			PACKAGE
			${package}
			REQUIRED
		)
		include_directories (${PACKAGE_INCLUDE_DIRS})
		link_directories (${PACKAGE_LIBRARY_DIRS})
		foreach (local_library ${PACKAGE_LIBRARIES})
			list (APPEND local_libraries ${local_library})
		endforeach ()
	endforeach ()

	add_library (${name} ${type} ${c_sources} ${ARGS_C_SOURCES})
	target_link_libraries (${name}
		${VALA_LIBRARIES}
		${local_libraries}
	)
endfunction ()
