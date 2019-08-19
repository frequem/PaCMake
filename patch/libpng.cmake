pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch_preconfigure package version dir)
	pacmake_textfile_insert("${dir}/source/CMakeLists.txt" 853 "          INCLUDES DESTINATION include\n")
	
	pacmake_textfile_insert("${dir}/source/CMakeLists.txt" 767 "  return()\n")#don't create symlinks
	
	pacmake_textfile_insert("${dir}/source/CMakeLists.txt" 200 "set(PNG_LIB_NAME png)\n")
	pacmake_textfile_insert("${dir}/source/CMakeLists.txt" 199 "#")
	
	pacmake_textfile_replace("${dir}/source/CMakeLists.txt" "PNG_SHARED" "BUILD_SHARED_LIBS")
	pacmake_textfile_replace("${dir}/source/CMakeLists.txt" "PNG_STATIC" "NOT BUILD_SHARED_LIBS")
	pacmake_textfile_insert("${dir}/source/CMakeLists.txt" 53 "#")
	pacmake_textfile_insert("${dir}/source/CMakeLists.txt" 54 "#")
	
	pacmake_textfile_insert("${dir}/source/CMakeLists.txt" 30 "set(PNGLIB_NAME libpng)\n")
	pacmake_textfile_insert("${dir}/source/CMakeLists.txt" 29 "#")
	
	pacmake_textfile_replace("${dir}/source/CMakeLists.txt" "png_static" "png")
endfunction(pacmake_patch_preconfigure)

function(pacmake_patch_prebuild package version dir)
endfunction(pacmake_patch_prebuild)

function(pacmake_patch_postbuild package version dir)
endfunction(pacmake_patch_postbuild)

function(pacmake_patch_postinstall package version dir)
	file(RENAME "${dir}/install/lib/libpng/libpng.cmake" "${dir}/install/lib/libpng/libpngConfig.cmake")
endfunction(pacmake_patch_postinstall)
