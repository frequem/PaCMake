pacmake_include(textfile)

function(pacmake_patch patchdir sourcedir package version)
	pacmake_textfile_read("${patchdir}/files/CMakeLists.txt" cmakelists)
	string(REPLACE "@@@___VERSION___@@@" "${version}" cmakelists "${cmakelists}")
	pacmake_textfile_write("${sourcedir}/CMakeLists.txt" ${cmakelists})
	
	#disable header only
	pacmake_textfile_replace("${sourcedir}/include/glatter/glatter_config.h" 
		"#define GLATTER_HEADER_ONLY"
		"//#define GLATTER_HEADER_ONLY"
	)
endfunction(pacmake_patch)
