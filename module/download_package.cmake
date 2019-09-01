pacmake_include(package_property)
pacmake_include(log)

#pacmake_download_package(name version out_dir)
function(pacmake_download_package args_NAME args_VERSION out_dir)
	set(dir "${PACMAKE_PACKAGE_HOME}/download/${args_NAME}/${args_VERSION}")
	set(${out_dir} "${dir}" PARENT_SCOPE)
	if(EXISTS "${dir}/download.DONE")
		pacmake_log(INFO "${args_NAME}(${args_VERSION}) sources exist, skipping download...")
		return()
	endif()
		
	pacmake_log(INFO "Downloading ${args_NAME}(${args_VERSION})...")
	
	pacmake_get_download_properties(${args_NAME} ${args_VERSION} prop_list)
	
	if(NOT prop_list)
		pacmake_log(ERROR "pacmake_download_package(${args_NAME}, ${args_VERSION}): No properties found. Does the package exist and is the version correct?")
		message(FATAL_ERROR)
	endif()
		
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
		"-H${dir}"
		"-B${dir}/prebuild"
		"-G${CMAKE_GENERATOR}"
		"-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
		"-DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}"
		"-DCMAKE_SYSTEM_VERSION=${CMAKE_SYSTEM_VERSION}"
		${android_params}
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
	file(WRITE "${dir}/download.DONE" "")
endfunction(pacmake_download_package)
