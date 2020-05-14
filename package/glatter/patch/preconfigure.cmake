pacmake_include(textfile)

function(pacmake_patch patchdir sourcedir package version)
	file(WRITE "${sourcedir}/${package}Config.cmake"
		"include(CMakeFindDependencyMacro)\n"
		"find_dependency(OpenGL REQUIRED)\n"
		"include(\"\${CMAKE_CURRENT_LIST_DIR}/${package}Targets.cmake\")\n"
	)
	
	pacmake_textfile_read("${patchdir}/files/CMakeLists.txt" cmakelists)
	string(REPLACE "@@@___VERSION___@@@" "${version}" cmakelists "${cmakelists}")
	pacmake_textfile_write("${sourcedir}/CMakeLists.txt" ${cmakelists})
	
	#disable header only
	pacmake_textfile_replace("${sourcedir}/include/glatter/glatter_config.h" 
		"#define GLATTER_HEADER_ONLY"
		"//#define GLATTER_HEADER_ONLY"
	)
	#disable debug build
	pacmake_textfile_replace("${sourcedir}/include/glatter/glatter_config.h" 
		"#define GLATTER_LOG_ERRORS"
		"//#define GLATTER_LOG_ERRORS"
	)
endfunction(pacmake_patch)
