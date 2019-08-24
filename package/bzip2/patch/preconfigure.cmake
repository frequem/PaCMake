pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir workdir package version )
	pacmake_textfile_read("${patchdir}/files/CMakeLists.txt" cmakelists)
	string(REPLACE "@@@___VERSION___@@@" "${version}" cmakelists "${cmakelists}")
	pacmake_textfile_write("${workdir}/source/CMakeLists.txt" ${cmakelists})
endfunction(pacmake_patch)
