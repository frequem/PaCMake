pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir workdir package version)
	file(APPEND "${workdir}/source/CMakeLists.txt"
		"install(TARGETS harfbuzz"
		"\tEXPORT harfbuzzConfig\n"
		"\tARCHIVE DESTINATION \${CMAKE_INSTALL_LIBDIR}\n"
		"\tLIBRARY DESTINATION \${CMAKE_INSTALL_LIBDIR}\n"
		"\tRUNTIME DESTINATION \${CMAKE_INSTALL_BINDIR}\n"
		"\tINCLUDES DESTINATION \${CMAKE_INSTALL_INCLUDEDIR}/harfbuzz\n"
		"\tFRAMEWORK DESTINATION Library/Frameworks\n"
		")\n"
		"install(EXPORT harfbuzzConfig\n"
		"\tNAMESPACE harfbuzz::\n"
		"\tDESTINATION \${CMAKE_INSTALL_LIBDIR}/cmake/harfbuzz\n"
		")"
	)
	pacmake_textfile_replace("${workdir}/source/CMakeLists.txt"
		"enable_testing()"
		"if(NOT MSVC)\n\tlist(APPEND THIRD_PARTY_LIBS m)\nendif()"
	)
endfunction(pacmake_patch)
