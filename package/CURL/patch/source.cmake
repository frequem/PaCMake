pacmake_include(textfile)

function(pacmake_patch packageName packageVariant packageVersion workingDirectory)
	pacmake_textfile_replace("${workingDirectory}/CMakeLists.txt" "${workingDirectory}/CMakeLists.txt"
		STRING
		"find_package(Cares MODULE REQUIRED)" "find_package(c-ares REQUIRED)"
		"list(APPEND CURL_LIBS CURL::cares)" "list(APPEND CURL_LIBS c-ares::cares)"
		"\"\${CMAKE_CURRENT_SOURCE_DIR}/CMake/FindCares.cmake\"" ""
	)

	pacmake_textfile_replace("${workingDirectory}/CMake/curl-config.in.cmake" "${workingDirectory}/CMake/curl-config.in.cmake"
		STRING
		"find_dependency(Cares MODULE)" "find_dependency(c-ares)"
		"list(APPEND _curl_libs CURL::cares)" "list(APPEND _curl_libs c-ares::cares)"
	)
endfunction(pacmake_patch)
