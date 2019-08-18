pacmake_include(package_property)
pacmake_include(log)

#pacmake_download_package(name version out_dir)
function(pacmake_download_package args_NAME args_VERSION out_dir)
	pacmake_log(INFO "Fetching ${args_NAME}(${args_VERSION})...")
	
	pacmake_get_download_properties(${args_NAME} ${args_VERSION} prop_list)
	
	if(NOT prop_list)
		pacmake_log(ERROR "pacmake_download_package(${args_NAME}, ${args_VERSION}): No properties found. Does the package exist and is the version correct?")
		message(FATAL_ERROR)
	endif()
	
	set(dir "${CMAKE_BINARY_DIR}/PaCMake/download/${args_NAME}/${args_VERSION}")
	
	file(
		WRITE
		"${dir}/CMakeLists.txt"
		"cmake_minimum_required(VERSION 3.0.2)\n"
		"project(${args_NAME} LANGUAGES NONE)\n"
		"include(ExternalProject)\n"
		"ExternalProject_Add(\n"
		"\t${args_NAME}\n"
		"\tDOWNLOAD_DIR \"${dir}\"\n"
		"\tSOURCE_DIR \"${dir}/source\"\n"
		"\tCONFIGURE_COMMAND \"\"\n"
		"\tBUILD_COMMAND \"\"\n"
		"\tINSTALL_COMMAND \"\"\n"
		"${prop_list}"
		")\n"
	)
	execute_process(
		COMMAND ${CMAKE_COMMAND}
		"-H${dir}"
		"-B${dir}/prebuild"
		"-G${CMAKE_GENERATOR}"
		"-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
		WORKING_DIRECTORY "${dir}"
		RESULT_VARIABLE result
	)
	if(NOT result EQUAL 0)
		pacmake_log(ERROR "pacmake_download_package(${args_NAME}, ${args_VERSION}): Could not configure download.")
		message(FATAL_ERROR)
	endif()
	execute_process(
		COMMAND "${CMAKE_COMMAND}" --build "prebuild/"
		WORKING_DIRECTORY "${dir}"
		RESULT_VARIABLE result
	)
	if(NOT result EQUAL 0)
		pacmake_log(ERROR "pacmake_download_package(${args_NAME}, ${args_VERSION}): Could not download sources.")
		message(FATAL_ERROR)
	endif()
	set(${out_dir} "${dir}" PARENT_SCOPE)
endfunction(pacmake_download_package)
