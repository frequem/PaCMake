pacmake_include(log)

function(pacmake_patch_preconfigure package version dir)
	if(NOT EXISTS "${dir}/source/zlibConfig.cmake")
		file(WRITE "${dir}/source/zlibConfig.cmake"
			"include(\"\${CMAKE_CURRENT_LIST_DIR}/zlibTargets.cmake\")"
		)
		file(APPEND "${dir}/source/CMakeLists.txt"
			"install(TARGETS zlib zlibstatic\n"
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
	endif()
endfunction(pacmake_patch_preconfigure)

function(pacmake_patch_prebuild package version dir)
endfunction(pacmake_patch_prebuild)

function(pacmake_patch_postbuild package version dir)
endfunction(pacmake_patch_postbuild)

function(pacmake_patch_postinstall package version dir)
endfunction(pacmake_patch_postinstall)
