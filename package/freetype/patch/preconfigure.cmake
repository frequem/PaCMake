pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir sourcedir package version)
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 410
		"if(NOT MSVC)\n"
		"  target_link_libraries(freetype PRIVATE m)\n"
		"endif()\n"
	)
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "find_package(HarfBuzz 1.3.0" "find_package(harfbuzz")
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "find_package(PNG" "find_package(libpng")
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "find_package(ZLIB" "find_package(zlib")
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "find_package(BZip2" "find_package(bzip2")
endfunction(pacmake_patch)
