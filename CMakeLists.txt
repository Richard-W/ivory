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

add_subdirectory(resources)
add_subdirectory(src)
