pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir sourcedir package version)
	file(APPEND "${sourcedir}/CMakeLists.txt"
		"install(\n"
		"\tEXPORT oggTargets\n"
		"\tFILE \${PROJECT_NAME}Config.cmake\n"
		"\tNAMESPACE \"\${PROJECT_NAME}::\"\n"
		"\tDESTINATION \"\${CMAKE_INSTALL_LIBDIR}/cmake/\${PROJECT_NAME}\"\n"
		")\n"
	)
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 111 "    INCLUDES DESTINATION \${CMAKE_INSTALL_INCLUDEDIR}\n")
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 107 "    EXPORT oggTargets\n")
	
endfunction(pacmake_patch)
