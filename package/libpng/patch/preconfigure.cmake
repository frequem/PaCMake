pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir workdir package version)
	pacmake_textfile_insert("${workdir}/source/CMakeLists.txt" 853 "          INCLUDES DESTINATION include\n")
	
	pacmake_textfile_insert("${workdir}/source/CMakeLists.txt" 767 "  return()\n")#don't create symlinks
	
	pacmake_textfile_insert("${workdir}/source/CMakeLists.txt" 200 "set(PNG_LIB_NAME png)\n")
	pacmake_textfile_insert("${workdir}/source/CMakeLists.txt" 199 "#")
	
	pacmake_textfile_replace("${workdir}/source/CMakeLists.txt" "PNG_SHARED" "BUILD_SHARED_LIBS")
	pacmake_textfile_replace("${workdir}/source/CMakeLists.txt" "PNG_STATIC" "NOT BUILD_SHARED_LIBS")
	pacmake_textfile_insert("${workdir}/source/CMakeLists.txt" 53 "#")
	pacmake_textfile_insert("${workdir}/source/CMakeLists.txt" 54 "#")
	
	pacmake_textfile_insert("${workdir}/source/CMakeLists.txt" 30 "set(PNGLIB_NAME libpng)\n")
	pacmake_textfile_insert("${workdir}/source/CMakeLists.txt" 29 "#")
	
	pacmake_textfile_replace("${workdir}/source/CMakeLists.txt" "png_static" "png")
	pacmake_textfile_replace("${workdir}/source/CMakeLists.txt" "target_link_libraries(png " "target_link_libraries(png PRIVATE ")
endfunction(pacmake_patch)
