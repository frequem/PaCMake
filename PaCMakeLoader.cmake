cmake_minimum_required(VERSION 3.0.2)

function(pacmake_download dir)
	if(EXISTS "${dir}/download.DONE")
		message("PACMAKE sources exist, skipping download...")
		return()
	endif()
	file(WRITE "${dir}/download.DONE" "")
	
	file(
		WRITE
		"${dir}/CMakeLists.txt"
		"cmake_minimum_required(VERSION 3.0.2)\n"
		"project(PaCMake LANGUAGES NONE)\n"
		"include(ExternalProject)\n"
		"ExternalProject_Add(\n"
		"\tPaCMake\n"
		"\tGIT_REPOSITORY \"https://github.com/frequem/PaCMake.git\"\n"
		"\tDOWNLOAD_DIR \"${dir}\"\n"
		"\tSOURCE_DIR \"${dir}/PaCMake\"\n"
		"\tCONFIGURE_COMMAND \"\"\n"
		"\tBUILD_COMMAND \"\"\n"
		"\tINSTALL_COMMAND \"\"\n"
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
		"-B${dir}/build"
		"-G${CMAKE_GENERATOR}"
		"-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
		"-DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}"
		"-DCMAKE_SYSTEM_VERSION=${CMAKE_SYSTEM_VERSION}"
		${android_params}
		WORKING_DIRECTORY "${dir}"
		RESULT_VARIABLE result
	)
	if(NOT result EQUAL 0)
		file(REMOVE "${dir}/download.DONE" "")
		message(FATAL_ERROR "PACMAKE LOADER: Could not configure PaCMake sources.")
	endif()
	execute_process(
		COMMAND "${CMAKE_COMMAND}" --build "build/"
		WORKING_DIRECTORY "${dir}"
		RESULT_VARIABLE result
	)
	if(NOT result EQUAL 0)
		file(REMOVE "${dir}/download.DONE" "")
		message(FATAL_ERROR "PACMAKE LOADER: Could not download PaCMake sources.")
	endif()
endfunction(pacmake_download)

if(NOT PACMAKE_PACKAGE_HOME)
	if(DEFINED ENV{HOME})
		set(PACMAKE_PACKAGE_HOME "$ENV{HOME}/.PaCMake" CACHE INTERNAL "PACMAKE_PACKAGE_HOME")
	elseif(DEFINED ENV{USERPROFILE})
		set(PACMAKE_PACKAGE_HOME "$ENV{USERPROFILE}/.PaCMake" CACHE INTERNAL "PACMAKE_PACKAGE_HOME")
	else()
		set(PACMAKE_PACKAGE_HOME "${CMAKE_BINARY_DIR}/PaCMake" CACHE INTERNAL "PACMAKE_PACKAGE_HOME")
	endif()
endif()

pacmake_download(${PACMAKE_PACKAGE_HOME})
include("${PACMAKE_PACKAGE_HOME}/PaCMake/PaCMake.cmake")
