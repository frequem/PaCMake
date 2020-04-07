pacmake_include(package_property)
pacmake_include(log)
pacmake_include(patch)

#pacmake_build_package(name version dir [STATIC|SHARED])
function(pacmake_build_package args_NAME args_VERSION dir args_TYPE)
	pacmake_get_package_property(GENERIC ${args_NAME} ${args_VERSION} DEPENDENCY_PREFIX_PATH dep_prefixes)
	pacmake_get_package_property(GENERIC ${args_NAME} ${args_VERSION} CMAKE_ARGS cmake_args)
	
	if("${args_TYPE}" STREQUAL "STATIC")
		set(build_shared OFF)
	elseif("${args_TYPE}" STREQUAL "SHARED")
		set(build_shared ON)
	else()
		pacmake_log(ERROR "pacmake_build_package(${args_NAME}, ${args_VERSION}): Unknown library type: ${args_TYPE}")
		message(FATAL_ERROR)
	endif()
	
	set(system_prefix "${CMAKE_SYSTEM_NAME}")
	if(CMAKE_SYSTEM_VERSION)
		string(APPEND system_prefix "_${CMAKE_SYSTEM_VERSION}")
	endif()
	if(CMAKE_ANDROID_ARCH_ABI)
		string(APPEND system_prefix "/${CMAKE_ANDROID_ARCH_ABI}")
	endif()
	
	set(source_dir "${dir}/source")
	set(build_dir "${dir}/build/${system_prefix}/${args_TYPE}")
	set(install_dir "${dir}/install/${system_prefix}/${args_TYPE}")
	set(patch_check_dir "${dir}/patch")
	
	if(EXISTS ${install_dir})
		pacmake_log(INFO "pacmake_build_package(${args_NAME}, ${args_VERSION}): Install directory exists, skipping build.")
		
		list(APPEND CMAKE_PREFIX_PATH ${install_dir})
		set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} CACHE INTERNAL "CMAKE_PREFIX_PATH")
		pacmake_set_package_property(GENERIC ${args_NAME} ${args_VERSION} INSTALL_PATH "${install_dir}")
		set(PACMAKE_PACKAGE_VERSION_${args_NAME} ${args_VERSION} CACHE INTERNAL "PACMAKE_PACKAGE_VERSION_${args_NAME}")
		
		return()
	endif()
	
	#create build dir for execute_process output
	if(NOT EXISTS ${build_dir})
		file(MAKE_DIRECTORY ${build_dir})
	endif()
	
	pacmake_run_patch(${args_NAME} ${args_VERSION} PRECONFIGURE ${source_dir} ${patch_check_dir})
	
	pacmake_log(INFO "pacmake_build_package(${args_NAME}, ${args_VERSION}): Configuring.")
	
	if(ANDROID)
		set(android_params
			"-DANDROID_TOOLCHAIN=${ANDROID_TOOLCHAIN}"
			"-DANDROID_ABI=${ANDROID_ABI}"
			"-DANDROID_PLATFORM=${ANDROID_PLATFORM}"
			"-DANDROID_STL=${ANDROID_STL}"
			"-DANDROID_PIE=${ANDROID_PIE}"
			"-DANDROID_CPP_FEATURES=${ANDROID_CPP_FEATURES}"
			"-DANDROID_ALLOW_UNDEFINED_SYMBOLS=${ANDROID_ALLOW_UNDEFINED_SYMBOLS}"
			"-DANDROID_ARM_MODE=${ANDROID_ARM_MODE}"
			"-DANDROID_ARM_NEON=${ANDROID_ARM_NEON}"
			"-DANDROID_DISABLE_FORMAT_STRING_CHECKS=${ANDROID_DISABLE_FORMAT_STRING_CHECKS}"
			"-DANDROID_CCACHE=${ANDROID_CCACHE}"
			"-DANDROID_NDK=${ANDROID_NDK}"
			"-DANDROID_TOOLCHAIN_NAME=${ANDROID_TOOLCHAIN_NAME}"
			"-DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL}"
			"-DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}"
		)
	endif()
	
	execute_process(
		COMMAND ${CMAKE_COMMAND}
		"-H${source_dir}"
		"-B${build_dir}"
		"-G${CMAKE_GENERATOR}"
		"-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
		"-DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}"
		"-DCMAKE_SYSTEM_VERSION=${CMAKE_SYSTEM_VERSION}"
		"-DCMAKE_INSTALL_PREFIX=${install_dir}/"
		"-DCMAKE_FIND_ROOT_PATH=${dep_prefixes}" #CMAKE_PREFIX_PATH doesn't work on android (CMAKE_FIND_ROOT_PATH_MODE_PACKAGE is set to ONLY)
		"-DCMAKE_PREFIX_PATH=${dep_prefixes}"
		"-DBUILD_SHARED_LIBS=${build_shared}"
		"-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
		"-DCMAKE_BUILD_TYPE=Release"
		${android_params}
		${cmake_args}
		WORKING_DIRECTORY "${dir}"
		OUTPUT_FILE "${build_dir}/pacmake_configure.log"
		ERROR_FILE "${build_dir}/pacmake_configure.log"
		RESULT_VARIABLE result
	)
	if(NOT result EQUAL 0)
		pacmake_log(ERROR "pacmake_build_package(${args_NAME}, ${args_VERSION}): Could not configure sources.")
		message(FATAL_ERROR)
	endif()
	
	pacmake_run_patch(${args_NAME} ${args_VERSION} PREBUILD ${source_dir} ${patch_check_dir})
	
	pacmake_log(INFO "pacmake_build_package(${args_NAME}, ${args_VERSION}): Building.")
	execute_process(
		COMMAND "${CMAKE_COMMAND}" --build "${build_dir}/"
		WORKING_DIRECTORY "${dir}"
		OUTPUT_FILE "${build_dir}/pacmake_build.log"
		ERROR_FILE "${build_dir}/pacmake_build.log"
		RESULT_VARIABLE result
	)
	if(NOT result EQUAL 0)
		pacmake_log(ERROR "pacmake_build_package(${args_NAME}, ${args_VERSION}): Could not build sources.")
		message(FATAL_ERROR)
	endif()
	
	pacmake_run_patch(${args_NAME} ${args_VERSION} POSTBUILD ${build_dir} "${patch_check_dir}/${system_prefix}/${args_TYPE}")
	
	pacmake_log(INFO "pacmake_build_package(${args_NAME}, ${args_VERSION}): Installing.")
	execute_process(
		COMMAND ${CMAKE_COMMAND} --build "." --target install
		WORKING_DIRECTORY "${build_dir}"
		OUTPUT_FILE "${build_dir}/pacmake_install.log"
		ERROR_FILE "${build_dir}/pacmake_install.log"
		RESULT_VARIABLE result
	)
	if(NOT result EQUAL 0)
		pacmake_log(ERROR "pacmake_build_package(${args_NAME}, ${args_VERSION}): Could not install.")
		message(FATAL_ERROR)
	endif()
	
	pacmake_run_patch(${args_NAME} ${args_VERSION} POSTINSTALL ${install_dir} "${patch_check_dir}/${system_prefix}/${args_TYPE}")
	
	#append to prefix path + set install_path
	list(APPEND CMAKE_PREFIX_PATH ${install_dir})
	set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} CACHE INTERNAL "CMAKE_PREFIX_PATH")
	pacmake_set_package_property(GENERIC ${args_NAME} ${args_VERSION} INSTALL_PATH "${install_dir}")
	set(PACMAKE_PACKAGE_VERSION_${args_NAME} ${args_VERSION} CACHE INTERNAL "PACMAKE_PACKAGE_VERSION_${args_NAME}")
endfunction(pacmake_build_package)
