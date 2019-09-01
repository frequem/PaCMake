pacmake_include(log)
pacmake_include(patch)

#pacmake_build_package(name version dir [STATIC|SHARED])
function(pacmake_build_package name version dir type)
	pacmake_get_package_property(${name} ${version} DEPENDENCY_PREFIX_PATH dep_prefixes)
	pacmake_get_package_property(${name} ${version} CMAKE_ARGS cmake_args)
	
	if("${type}" STREQUAL "STATIC")
		set(build_shared OFF)
	elseif("${type}" STREQUAL "SHARED")
		set(build_shared ON)
	else()
		pacmake_log(ERROR "pacmake_build_package(${name}, ${version}): Unknown library type: ${type}")
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
	set(build_dir "${dir}/build/${system_prefix}")
	set(install_dir "${dir}/install/${system_prefix}/${type}")
	
	pacmake_run_patch(${name} ${version} PRECONFIGURE ${dir} ${source_dir})
	
	pacmake_log(INFO "pacmake_build_package(${name}, ${version}): Configuring...")
	
	if(ANDROID)
		set(android_params
			"-DANDROID_PLATFORM=${ANDROID_PLATFORM}"
			"-DANDROID_NDK=${ANDROID_NDK}"
			"-DCMAKE_ANDROID_ARCH_ABI=${CMAKE_ANDROID_ARCH_ABI}"
			"-DCMAKE_ANDROID_NDK=${CMAKE_ANDROID_NDK}"
			"-DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}"
			"-DANDROID_TOOLCHAIN_NAME=${ANDROID_TOOLCHAIN_NAME}"
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
		"-DCMAKE_PREFIX_PATH=${dep_prefixes}"
		"-DBUILD_SHARED_LIBS=${build_shared}"
		"-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
		"-DCMAKE_BUILD_TYPE=Release"
		${android_params}
		${cmake_args}
		WORKING_DIRECTORY "${dir}"
		RESULT_VARIABLE result
	)
	if(NOT result EQUAL 0)
		pacmake_log(ERROR "pacmake_build_package(${args_NAME}, ${args_VERSION}): Could not configure sources.")
		message(FATAL_ERROR)
	endif()
	
	pacmake_run_patch(${name} ${version} PREBUILD ${dir} ${source_dir})
	
	pacmake_log(INFO "pacmake_build_package(${name}, ${version}): Building...")
	execute_process(
		COMMAND "${CMAKE_COMMAND}" --build "${build_dir}/"
		WORKING_DIRECTORY "${dir}"
		RESULT_VARIABLE result
	)
	if(NOT result EQUAL 0)
		pacmake_log(ERROR "pacmake_build_package(${args_NAME}, ${args_VERSION}): Could not build sources.")
		message(FATAL_ERROR)
	endif()
	
	pacmake_run_patch(${name} ${version} POSTBUILD ${dir} ${build_dir})
	
	pacmake_log(INFO "pacmake_build_package(${name}, ${version}): Installing...")
	execute_process(
		COMMAND ${CMAKE_COMMAND} --build "." --target install
		WORKING_DIRECTORY "${build_dir}"
		RESULT_VARIABLE result
	)
	if(NOT result EQUAL 0)
		pacmake_log(ERROR "pacmake_build_package(${args_NAME}, ${args_VERSION}): Could not install.")
		message(FATAL_ERROR)
	endif()
	
	pacmake_run_patch(${name} ${version} POSTINSTALL ${dir} ${install_dir})
	
	#append to prefix path + set install_path
	list(APPEND CMAKE_PREFIX_PATH ${install_dir})
	set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} CACHE INTERNAL "CMAKE_PREFIX_PATH")
	pacmake_set_package_property(${name} ${version} INSTALL_PATH GENERIC "${install_dir}")
	set(PACMAKE_PACKAGE_VERSION_${name} ${version} CACHE INTERNAL "PACMAKE_PACKAGE_VERSION_${name}")
endfunction(pacmake_build_package)
