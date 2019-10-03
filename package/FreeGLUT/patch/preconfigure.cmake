pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir sourcedir package version)
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 35 "#") # FREEGLUT_BUILD_SHARED_LIBS
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 36 "#") # FREEGLUT_BUILD_STATIC_LIBS
	
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "FREEGLUT_BUILD_SHARED_LIBS" "BUILD_SHARED_LIBS")
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "FREEGLUT_BUILD_STATIC_LIBS" "NOT BUILD_SHARED_LIBS")
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "freeglut_static" "freeglut")
endfunction(pacmake_patch)
