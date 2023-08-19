pacmake_include(textfile)

function(pacmake_patch packageName packageVersion workingDirectory)
	pacmake_textfile_replace("${workingDirectory}/CMakeLists.txt" "zlib zlibstatic" "zlib")
	pacmake_textfile_replace("${workingDirectory}/CMakeLists.txt" "add_library(zlib SHARED" "add_library(zlib")
	pacmake_textfile_replace("${workingDirectory}/CMakeLists.txt" "add_library(zlibstatic STATIC" "#add_library(zlibstatic STATIC")

	file(APPEND "${workingDirectory}/CMakeLists.txt"
		"\n"
		"install(TARGETS zlib\n"
		"\tEXPORT \"\${PROJECT_NAME}Targets\"\n"
		"\tRUNTIME DESTINATION \"\${INSTALL_BIN_DIR}\"\n"
		"\tARCHIVE DESTINATION \"\${INSTALL_LIB_DIR}\"\n"
		"\tLIBRARY DESTINATION \"\${INSTALL_LIB_DIR}\"\n"
		"\tINCLUDES DESTINATION \"\${INSTALL_INC_DIR}\"\n"
		")\n"
		"\n"
		"include(CMakePackageConfigHelpers)\n"
		"write_basic_package_version_file(\"\${CMAKE_BINARY_DIR}/\${PROJECT_NAME}ConfigVersion.cmake\"\n"
		"\tVERSION \${VERSION}\n"
		"\tCOMPATIBILITY AnyNewerVersion\n"
		")\n"
		"\n"
		"install(\n"
		"\tFILES\n"
		"\t\"\${CMAKE_BINARY_DIR}/\${PROJECT_NAME}ConfigVersion.cmake\"\n"
		"\tDESTINATION \"\${INSTALL_LIB_DIR}/cmake/\${PROJECT_NAME}\"\n"
		")\n"
		"\n"
		"install(\n"
		"\tEXPORT \"\${PROJECT_NAME}Targets\"\n"
		"\tFILE \"\${PROJECT_NAME}Config.cmake\"\n"
		"\tNAMESPACE \"\${PROJECT_NAME}::\"\n"
		"\tDESTINATION \"\${INSTALL_LIB_DIR}/cmake/\${PROJECT_NAME}\"\n"
		")"
	)
endfunction(pacmake_patch)
