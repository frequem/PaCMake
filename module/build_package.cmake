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
	
	set(source_dir "${dir}/source")
	set(build_dir "${dir}/build")
	set(install_dir "${dir}/install/${type}")
	
	pacmake_run_patch(${name} ${version} PRECONFIGURE ${source_dir})
	
	pacmake_log(INFO "pacmake_build_package(${name}, ${version}): Configuring...")
	execute_process(
		COMMAND ${CMAKE_COMMAND}
		"-H${source_dir}"
		"-B${build_dir}"
		"-G${CMAKE_GENERATOR}"
		"-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
		"-DCMAKE_INSTALL_PREFIX=${install_dir}/"
		"-DCMAKE_PREFIX_PATH=${dep_prefixes}"
		"-DBUILD_SHARED_LIBS=${build_shared}"
		"-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
		"-DCMAKE_BUILD_TYPE=Release"
		${cmake_args}
		WORKING_DIRECTORY "${dir}"
		RESULT_VARIABLE result
	)
	if(NOT result EQUAL 0)
		pacmake_log(ERROR "pacmake_build_package(${args_NAME}, ${args_VERSION}): Could not configure sources.")
		message(FATAL_ERROR)
	endif()
	
	pacmake_run_patch(${name} ${version} PREBUILD ${source_dir})
	
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
	
	pacmake_run_patch(${name} ${version} POSTBUILD ${build_dir})
	
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
	
	pacmake_run_patch(${name} ${version} POSTINSTALL ${install_dir})
endfunction(pacmake_build_package)
