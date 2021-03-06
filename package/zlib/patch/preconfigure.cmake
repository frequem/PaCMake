pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir sourcedir package version)
	file(WRITE "${sourcedir}/zlibConfig.cmake"
		"include(\"\${CMAKE_CURRENT_LIST_DIR}/zlibTargets.cmake\")"
	)
	#change target name from zlib::zlibstatic to zlib::zlib
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "zlibstatic" "zlib")
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 204 "   set_target_properties(zlib PROPERTIES OUTPUT_NAME z)\n")
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 203 "#")
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 187 "endif()\n")
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 186 "else()\n    ")
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 185 "if(BUILD_SHARED_LIBS)\n    ")
	
	file(APPEND "${sourcedir}/CMakeLists.txt"
		"install(TARGETS zlib\n"
		"\tEXPORT \"\${PROJECT_NAME}Targets\"\n"
		"\tRUNTIME DESTINATION \"\${INSTALL_BIN_DIR}\"\n"
		"\tARCHIVE DESTINATION \"\${INSTALL_LIB_DIR}\"\n"
		"\tLIBRARY DESTINATION \"\${INSTALL_LIB_DIR}\"\n"
		"\tINCLUDES DESTINATION \"\${INSTALL_INC_DIR}\"\n"
		")\n"
		"include(CMakePackageConfigHelpers)\n"
		"write_basic_package_version_file(\"\${CMAKE_BINARY_DIR}/\${PROJECT_NAME}ConfigVersion.cmake\"\n"
		"\tVERSION \${VERSION}\n"
		"\tCOMPATIBILITY AnyNewerVersion\n"
		")\n"
		"\n"
		"install(\n"
		"\tFILES\n"
		"\t\"\${CMAKE_CURRENT_SOURCE_DIR}/\${PROJECT_NAME}Config.cmake\"\n"
		"\t\"\${CMAKE_BINARY_DIR}/\${PROJECT_NAME}ConfigVersion.cmake\"\n"
		"\tDESTINATION \"\${INSTALL_LIB_DIR}/cmake/\${PROJECT_NAME}\"\n"
		")\n"
		"\n"
		"install(\n"
		"\tEXPORT \"\${PROJECT_NAME}Targets\"\n"
		"\tFILE \"\${PROJECT_NAME}Targets.cmake\"\n"
		"\tNAMESPACE \"\${PROJECT_NAME}::\"\n"
		"\tDESTINATION \"\${INSTALL_LIB_DIR}/cmake/\${PROJECT_NAME}\"\n"
		")"
	)
endfunction(pacmake_patch)
