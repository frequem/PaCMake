cmake_minimum_required(VERSION 3.0.2)

option(PACMAKE_PRINT_WARNINGS "Print PacMake warnings" ON)
option(PACMAKE_PRINT_ERRORS "Print PacMake errors" ON)
option(PACMAKE_PRINT_INFO "Print PacMake info" ON)
option(PACMAKE_DEBUG "Print all PacMake messages" OFF)
set(PACMAKE_DEFAULT_LIBRARY_TYPE STATIC)

set(PACMAKE_BASEDIR ${CMAKE_CURRENT_LIST_DIR} CACHE INTERNAL "PACMAKE_BASEDIR")

function(pacmake_include MODULE)
	include("${PACMAKE_BASEDIR}/module/${MODULE}.cmake")
endfunction(pacmake_include)

pacmake_include(add_package)
pacmake_include(scan_packages)

pacmake_scan_packages()
