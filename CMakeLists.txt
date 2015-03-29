cmake_minimum_required(VERSION 2.6)
project(ivory)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

find_package(Vala REQUIRED)
find_package(PkgConfig REQUIRED)
include(UseVala)

include(ConfigureWrapper)

set(IVORY_SRCDIR ${CMAKE_CURRENT_SOURCE_DIR})
set(IVORY_RESDIR ${IVORY_SRCDIR}/resources)
set(IVORY_BINDIR ${CMAKE_CURRENT_BINARY_DIR})
set(IVORY_BINRESDIR ${IVORY_BINDIR}/resources)

set(ivory_vala_packages
	gtk+-3.0
	webkit2gtk-4.0
)
set(ivory_vala_options
	--gresources=${IVORY_RESDIR}/resources.xml
	--vapi-comments
	--thread
	-g
)

configure_file(
	${CMAKE_CURRENT_SOURCE_DIR}/config.h.in
	${CMAKE_CURRENT_BINARY_DIR}/config.h
	@ONLY
)

add_subdirectory(resources)
add_subdirectory(src)

enable_testing()
add_subdirectory(tests)
