include(CMakeParseArguments)

pacmake_include(download_package)
pacmake_include(package_property)
pacmake_include(build_package)
pacmake_include(default_version)
pacmake_include(log)

#pacmake_include_package(name)
function(pacmake_include_package name)
	set(dir "${PACMAKE_BASEDIR}/package/${name}")
	if(IS_DIRECTORY ${dir} AND EXISTS "${dir}/package.cmake")
		include("${dir}/package.cmake")
	endif()
endfunction(pacmake_include_package)

#pacmake_add_package(name [STATIC|SHARED] VERSION version)
function(pacmake_add_package)
	cmake_parse_arguments(args "STATIC;SHARED" "VERSION" "" ${ARGN})
	
	list(LENGTH args_UNPARSED_ARGUMENTS unparsed_length)
	if(NOT ${unparsed_length} EQUAL 1)
		pacmake_log(ERROR "pacmake_add_package: Invalid arguments.")
		message(FATAL_ERROR)
	endif()
		
	set(args_NAME "${args_UNPARSED_ARGUMENTS}")
	if(${args_STATIC})
		set(args_TYPE STATIC)
	elseif(${args_SHARED})
		set(args_TYPE SHARED)
	endif()
	
	if(NOT args_NAME)
		pacmake_log(ERROR "pacmake_add_package: No name specified")
		message(FATAL_ERROR)
	endif()
	
	list(FIND PACMAKE_PACKAGE_LIST ${args_NAME} package_index)
	if(${package_index} LESS 0)
		pacmake_log(INFO "pacmake_add_package(${args_NAME}): Including package.")
		pacmake_include_package(${args_NAME})
		
		list(FIND PACMAKE_PACKAGE_LIST ${args_NAME} package_index)
		if(${package_index} LESS 0)
			pacmake_log(ERROR "pacmake_add_package(${args_NAME}): Package could not be found.")
			message(FATAL_ERROR)
		endif()
	endif()
	
	if(NOT args_VERSION)
		pacmake_get_default_version(${args_NAME} args_VERSION)
		pacmake_log(INFO "pacmake_add_package(${args_NAME}): No version specified, using default.")
	endif()
	if(NOT args_VERSION)
		pacmake_log(ERROR "pacmake_add_package(${args_NAME}): No default version set.")
		message(FATAL_ERROR)
	endif()
	
	pacmake_get_package_property(GENERIC ${args_NAME} ${args_VERSION} REGISTERED is_registered)
	if(NOT is_registered)
		pacmake_log(ERROR "pacmake_add_package(${args_NAME}, ${args_VERSION}): Version could not be found.")
		message(FATAL_ERROR)
	endif()
		
	if(NOT args_TYPE)
		pacmake_log(INFO "pacmake_add_package(${args_NAME}): No library type specified, using default(${PACMAKE_DEFAULT_LIBRARY_TYPE}).")
		set(args_TYPE ${PACMAKE_DEFAULT_LIBRARY_TYPE})
	endif()
	
	pacmake_get_package_property(GENERIC ${args_NAME} ${args_VERSION} DEPENDENCIES deps)
	foreach(dep IN ITEMS ${deps})
		pacmake_log(INFO "pacmake_add_package(${args_NAME}, ${args_VERSION}): Depends on ${dep}, running pacmake_add_package.")		
		pacmake_add_package(${dep})
		#version should be set now
		
		#append dependency prefix + prefixes of dependencies of dependencies...
		pacmake_get_package_property(GENERIC ${dep} ${PACMAKE_PACKAGE_VERSION_${dep}} INSTALL_PATH dep_install_path)
		pacmake_get_package_property(GENERIC ${dep} ${PACMAKE_PACKAGE_VERSION_${dep}} DEPENDENCY_PREFIX_PATH dep_deps_prefixes)
		
		set(prefixes ${dep_install_path} ${dep_deps_prefixes})
		
		pacmake_get_package_property(GENERIC ${args_NAME} ${args_VERSION} DEPENDENCY_PREFIX_PATH dep_prefixes)
		foreach(prefix IN ITEMS ${prefixes})
			list(FIND dep_prefixes "${prefix}" prefix_index)
			if(${prefix_index} LESS 0) # add dependency if not added already
				list(APPEND dep_prefixes ${prefix})
				pacmake_set_package_property(GENERIC ${args_NAME} ${args_VERSION} DEPENDENCY_PREFIX_PATH ${dep_prefixes})
			endif()
		endforeach()
	endforeach()
	
	pacmake_download_package(${args_NAME} ${args_VERSION} dir)
	pacmake_build_package(${args_NAME} ${args_VERSION} ${dir} ${args_TYPE})
	
	pacmake_get_package_property(GENERIC ${args_NAME} ${args_VERSION} INSTALL_PATH install_path)
	pacmake_get_package_property(GENERIC ${args_NAME} ${args_VERSION} DEPENDENCY_PREFIX_PATH dep_prefixes)
	
	pacmake_log(INFO "pacmake_add_package(${args_NAME}, ${args_VERSION}): Running find_package.")
	find_package(${args_NAME} REQUIRED 
		NO_DEFAULT_PATH
		PATHS ${dep_prefixes} ${install_path}
	)
endfunction(pacmake_add_package)
