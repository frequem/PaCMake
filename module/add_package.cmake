include(CMakeParseArguments)

pacmake_include(parse_args)
pacmake_include(download_package)
pacmake_include(build_package)
pacmake_include(default_version)
pacmake_include(log)

#pacmake_include_package(name)
function(pacmake_include_packages name)
	set(dir "${PACMAKE_BASEDIR}/package/${name}")
	if(IS_DIRECTORY ${dir} AND EXISTS "${dir}/package.cmake")
		include("${dir}/package.cmake")
	endif()
endfunction(pacmake_include_packages)

#pacmake_add_package(name [STATIC|SHARED] VERSION version)
function(pacmake_add_package)
	cmake_parse_arguments(args "" "VERSION" "" ${ARGN})
	pacmake_parse_args(args_NAME args_TYPE VALUES ${args_UNPARSED_ARGUMENTS})
	
	if(NOT args_NAME)
		pacmake_log(ERROR "pacmake_add_package: No name specified")
		message(FATAL_ERROR)
	endif()
	
	list(FIND PACMAKE_PACKAGE_LIST ${args_NAME} i)
	if(${i} LESS 0)
		pacmake_log(INFO "pacmake_add_package(${args_NAME}): Package is not yet registered, trying to include...")
		pacmake_include_packages(${args_NAME})
		
		list(FIND PACMAKE_PACKAGE_LIST ${args_NAME} i)
		if(${i} LESS 0)
			pacmake_log(ERROR "pacmake_add_package(${args_NAME}): Package could not be found.")
			message(FATAL_ERROR)
		endif()
	endif()
	
	if(NOT args_VERSION)
		pacmake_get_default_version(${args_NAME} args_VERSION)
		pacmake_log(INFO "pacmake_add_package(${args_NAME}): No version specified, using default version instead.")
	endif()
	if(NOT args_VERSION)
		pacmake_log(ERROR "pacmake_add_package(${args_NAME}): No version specified and no default version set.")
		message(FATAL_ERROR)
	endif()
	
	pacmake_get_package_property(${args_NAME} ${args_VERSION} REGISTERED is_registered)
	if(NOT is_registered)
		pacmake_log(ERROR "pacmake_add_package(${args_NAME}, ${args_VERSION}): Package could not be found.")
		message(FATAL_ERROR)
	endif()
		
	if(NOT args_TYPE)
		pacmake_log(WARNING "pacmake_add_package(${args_NAME}): No library type specified, using default(${PACMAKE_DEFAULT_LIBRARY_TYPE}).")
		set(args_TYPE ${PACMAKE_DEFAULT_LIBRARY_TYPE})
	endif()
	
	pacmake_get_package_property(${args_NAME} ${args_VERSION} DEPENDENCIES deps)
	foreach(dep IN ITEMS ${deps})
		pacmake_log(INFO "pacmake_add_package(${args_NAME}, ${args_VERSION}): Depends on ${dep}, running pacmake_add_package...")		
		pacmake_add_package(${dep})
		#version should be set now
		
		#append dependency prefix + prefixes of dependencies of dependencies...
		pacmake_get_package_property(${dep} ${PACMAKE_PACKAGE_VERSION_${dep}} INSTALL_PATH dep_install_path)
		pacmake_get_package_property(${dep} ${PACMAKE_PACKAGE_VERSION_${dep}} DEPENDENCY_PREFIX_PATH dep_deps_prefixes)
		
		set(prefixes ${dep_install_path} ${dep_deps_prefixes})
		
		pacmake_get_package_property(${args_NAME} ${args_VERSION} DEPENDENCY_PREFIX_PATH dep_prefixes)
		foreach(prefix in ITEMS ${prefixes})
			list(FIND dep_prefixes "${prefix}" i)
			if(${i} LESS 0)
				list(APPEND dep_prefixes ${prefix})
				pacmake_set_package_property(${args_NAME} ${args_VERSION} DEPENDENCY_PREFIX_PATH GENERIC ${dep_prefixes})
			endif()
		endforeach()
	endforeach()
	
	find_package(${args_NAME} QUIET 
		NO_CMAKE_ENVIRONMENT_PATH
		NO_CMAKE_SYSTEM_PATH
		NO_SYSTEM_ENVIRONMENT_PATH
		NO_CMAKE_PACKAGE_REGISTRY
		NO_CMAKE_BUILDS_PATH
		NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
		NO_CMAKE_FIND_ROOT_PATH
	)
	
	if(${${args_NAME}_FOUND})
		pacmake_log(INFO "pacmake_add_package(${args_NAME}): Package has already been installed, skipping build...")
		return()
	endif()
	
	pacmake_download_package(${args_NAME} ${args_VERSION} dir)
	pacmake_build_package(${args_NAME} ${args_VERSION} ${dir} ${args_TYPE})
	
	set(package_path "${dir}/install/${args_TYPE}")
	list(APPEND CMAKE_PREFIX_PATH ${package_path})
	set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} CACHE INTERNAL "CMAKE_PREFIX_PATH")
	pacmake_set_package_property(${args_NAME} ${args_VERSION} INSTALL_PATH GENERIC "${package_path}")
	set(PACMAKE_PACKAGE_VERSION_${args_NAME} ${args_VERSION} CACHE INTERNAL "PACMAKE_PACKAGE_VERSION_${args_NAME}")
	
	pacmake_log(INFO "pacmake_add_package(${args_NAME}, ${args_VERSION}): Running find_package...")
	find_package(${args_NAME} REQUIRED 
		NO_CMAKE_ENVIRONMENT_PATH
		NO_CMAKE_SYSTEM_PATH
		NO_SYSTEM_ENVIRONMENT_PATH
		NO_CMAKE_PACKAGE_REGISTRY
		NO_CMAKE_BUILDS_PATH
		NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
		NO_CMAKE_FIND_ROOT_PATH
	)
endfunction(pacmake_add_package)
