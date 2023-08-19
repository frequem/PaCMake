cmake_minimum_required(VERSION 3.6)

set(PACMAKE_PACKAGE_FETCH_INTERVAL 604800 CACHE STRING "Interval after which PaCMake packages are updated") # every 7 days
set(PACMAKE_FORCE_FETCH_PACKAGES "" CACHE STRING "Force fetch the given packages (supports regex).") # format: "<package1Name>[ <package1Version>];<package2Name>[ <package2Version>];..."
set(PACMAKE_FORCE_SOURCE_UPDATE_PACKAGES "" CACHE STRING "Force source updates (not necessarily a refetch) for the given packages (supports regex).") # format: "<package1Name>[ <package1Version>];<package2Name>[ <package2Version>];..."
if(BUILD_SHARED_LIBS)
	set(PACMAKE_DEFAULT_LIBRARY_TYPE "SHARED" CACHE STRING "Default PaCMake library type")
else()
	set(PACMAKE_DEFAULT_LIBRARY_TYPE "STATIC" CACHE STRING "Default PaCMake library type")
endif()

if(CMAKE_BUILD_TYPE)
	set(PACMAKE_BUILD_TYPE "${CMAKE_BUILD_TYPE}" CACHE STRING "Build type of PaCMake packages")
endif()
if(NOT PACMAKE_BUILD_TYPE)
	set(PACMAKE_BUILD_TYPE "Release" CACHE STRING "Build type of PaCMake packages" FORCE)
endif()


set(PACMAKE_BASEDIR "${CMAKE_CURRENT_LIST_DIR}" CACHE INTERNAL "")
get_filename_component(homeDirectory "${PACMAKE_BASEDIR}" DIRECTORY)
set(PACMAKE_HOME "${homeDirectory}" CACHE INTERNAL "")

if(PACMAKE_UPDATED) # clear loaded packages on update
	set(PACMAKE_PACKAGES_LOADED "" CACHE INTERNAL "") 
endif()

set(PACMAKE_LOG_INDENTATION_LEVEL 0 CACHE INTERNAL "")

set(PACMAKE_MODULES_INCLUDED "" CACHE INTERNAL "") # clear included module list
function(pacmake_include module)
	if(NOT ${module} IN_LIST PACMAKE_MODULES_INCLUDED)
		include("${PACMAKE_BASEDIR}/module/${module}.cmake")
		
		list(APPEND PACMAKE_MODULES_INCLUDED ${module})
		set(PACMAKE_MODULES_INCLUDED "${PACMAKE_MODULES_INCLUDED}" CACHE INTERNAL "")
	endif()
endfunction()

pacmake_include(add_package)
