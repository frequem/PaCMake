pacmake_include(package_property)
pacmake_include(log)

#pacmake_download_package(name version out_dir)
function(pacmake_download_package args_NAME args_VERSION out_dir)
	set(dir "${PACMAKE_PACKAGE_HOME}/download/${args_NAME}/${args_VERSION}")
	set(${out_dir} "${dir}" PARENT_SCOPE)
	if(EXISTS "${dir}/download.DONE")
		pacmake_log(INFO "pacmake_download_package(${args_NAME}, ${args_VERSION}): Sources exist, skipping download.")
		return()
	endif()
		
	pacmake_log(INFO "pacmake_download_package(${args_NAME}, ${args_VERSION}): Downloading sources.")
	
	pacmake_get_package_properties(DOWNLOAD ${args_NAME} ${args_VERSION} prop_list)
	
	if(NOT prop_list)
		pacmake_log(ERROR "pacmake_download_package(${args_NAME}, ${args_VERSION}): No properties found. Are the package and version correct?")
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
		"-H${dir}"
		"-B${dir}/prebuild"
		"-G${CMAKE_GENERATOR}"
		"-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
		"-DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}"
		"-DCMAKE_SYSTEM_VERSION=${CMAKE_SYSTEM_VERSION}"
		${android_params}
		WORKING_DIRECTORY "${dir}"
		OUTPUT_FILE "${dir}/pacmake_prebuild.log"
		ERROR_FILE "${dir}/pacmake_prebuild.log"
		RESULT_VARIABLE result
	)
	if(NOT result EQUAL 0)
		pacmake_log(ERROR "pacmake_download_package(${args_NAME}, ${args_VERSION}): Could not configure download.")
		message(FATAL_ERROR)
	endif()
	
	execute_process(
		COMMAND "${CMAKE_COMMAND}" --build "prebuild/"
		WORKING_DIRECTORY "${dir}"
		OUTPUT_FILE "${dir}/pacmake_download.log"
		ERROR_FILE "${dir}/pacmake_download.log"
		RESULT_VARIABLE result
	)
	if(NOT result EQUAL 0)
		pacmake_log(ERROR "pacmake_download_package(${args_NAME}, ${args_VERSION}): Could not download sources.")
		message(FATAL_ERROR)
	endif()
	
	file(WRITE "${dir}/download.DONE" "")
endfunction(pacmake_download_package)
