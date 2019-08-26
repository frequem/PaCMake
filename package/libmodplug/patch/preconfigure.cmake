pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir sourcedir package version )
	pacmake_textfile_read("${patchdir}/files/CMakeLists.txt" cmakelists)
	string(REPLACE "@@@___VERSION___@@@" "${version}" cmakelists "${cmakelists}")
	pacmake_textfile_write("${sourcedir}/CMakeLists.txt" ${cmakelists})
endfunction(pacmake_patch)
