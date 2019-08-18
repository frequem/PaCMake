cmake_minimum_required(VERSION 3.0.2)

function(pacmake_download dir)
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
	execute_process(
		COMMAND ${CMAKE_COMMAND}
		"-H${dir}"
		"-B${dir}/build"
		"-G${CMAKE_GENERATOR}"
		"-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
		WORKING_DIRECTORY "${dir}"
		RESULT_VARIABLE result
	)
	if(NOT result EQUAL 0)
		message(FATAL_ERROR "PACMAKE LOADER: Could not configure PaCMake sources.")
	endif()
	execute_process(
		COMMAND "${CMAKE_COMMAND}" --build "build/"
		WORKING_DIRECTORY "${dir}"
		RESULT_VARIABLE result
	)
	if(NOT result EQUAL 0)
		message(FATAL_ERROR "PACMAKE LOADER: Could not download PaCMake sources.")
	endif()
endfunction(pacmake_download)

pacmake_download(${CMAKE_BINARY_DIR})
include("${CMAKE_BINARY_DIR}/PaCMake/PaCMake.cmake")
