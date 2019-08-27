pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir sourcedir package version)
	pacmake_textfile_remove("${sourcedir}/CMakeLists.txt" 107 10)
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 301 "        INCLUDES DESTINATION \${CMAKE_INSTALL_INCLUDEDIR}/opus\n")
	
	pacmake_textfile_remove("${sourcedir}/opus_functions.cmake" 45 23)
	pacmake_textfile_remove("${sourcedir}/opus_functions.cmake" 63 2)
	pacmake_textfile_insert("${sourcedir}/opus_functions.cmake" 63 "set(PACKAGE_VERSION ${version} PARENT_SCOPE)\n")
endfunction(pacmake_patch)
