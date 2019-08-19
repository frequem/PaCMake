pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch_preconfigure package version dir)
	#remove harfbuzz find_package
	pacmake_textfile_insert("${dir}/source/CMakeLists.txt" 410
		"if(NOT MSVC)\n"
		"  target_link_libraries(freetype PRIVATE m)\n"
		"endif()\n"
	)
	pacmake_textfile_remove("${dir}/source/CMakeLists.txt" 187 5)
endfunction(pacmake_patch_preconfigure)

function(pacmake_patch_prebuild package version dir)
endfunction(pacmake_patch_prebuild)

function(pacmake_patch_postbuild package version dir)
endfunction(pacmake_patch_postbuild)

function(pacmake_patch_postinstall package version dir)
endfunction(pacmake_patch_postinstall)
