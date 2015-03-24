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

# Try to find the valac-executable
find_program (VALA_EXECUTABLE NAMES valac)
mark_as_advanced (VALA_EXECUTABLE)

# Get the version
if (VALA_EXECUTABLE)
	execute_process (
		COMMAND "${VALA_EXECUTABLE} --version"
		OUTPUT_STRIP_TRAILING_WHITESPACE
		OUTPUT_VARIABLE VALA_VERSION
	)
	string (REPLACE "Vala " "" VALA_VERSION "${VALA_VERSION}")
endif ()

# Find required libraries for vala
find_package (PkgConfig REQUIRED)
pkg_check_modules (
	VALA
	glib-2.0 gobject-2.0
	REQUIRED
)

# Check glib separately to provide GLIB_VERSION in UseVala.
pkg_check_modules (
	GLIB
	glib-2.0
	REQUIRED
)

# Handle standard args
include (FindPackageHandleStandardArgs)
find_package_handle_standard_args (Vala
	REQUIRED_VARS
		VALA_EXECUTABLE
		VALA_INCLUDE_DIRS
		VALA_LIBRARIES
	VERSION_VAR VALA_VERSION
)

# Set path to use-file
set (VALA_USE_FILE "${CMAKE_CURRENT_LIST_DIR}/UseVala.cmake")
