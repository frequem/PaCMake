pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir sourcedir package version)
	file(WRITE "${sourcedir}/${package}Config.cmake"
		"include(CMakeFindDependencyMacro)\n"
		"find_dependency(Opus)\n"
		"find_dependency(libogg)\n"
		"include(\"\${CMAKE_CURRENT_LIST_DIR}/${package}Targets.cmake\")\n"
	)
	
	pacmake_textfile_read("${patchdir}/files/CMakeLists.txt" cmakelists)
	string(REPLACE "@@@___VERSION___@@@" "${version}" cmakelists "${cmakelists}")
	pacmake_textfile_write("${sourcedir}/CMakeLists.txt" ${cmakelists})
endfunction(pacmake_patch)
