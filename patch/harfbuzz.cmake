pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch_preconfigure package version dir)
	file(APPEND "${dir}/source/CMakeLists.txt"
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
	pacmake_textfile_replace("${dir}/source/CMakeLists.txt"
		"enable_testing()"
		"if(NOT MSVC)\n\tlist(APPEND THIRD_PARTY_LIBS m)\nendif()"
	)
endfunction(pacmake_patch_preconfigure)

function(pacmake_patch_prebuild package version dir)
endfunction(pacmake_patch_prebuild)

function(pacmake_patch_postbuild package version dir)
endfunction(pacmake_patch_postbuild)

function(pacmake_patch_postinstall package version dir)
endfunction(pacmake_patch_postinstall)
