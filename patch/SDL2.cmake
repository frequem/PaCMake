pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch_preconfigure package version dir)
	#replace SDL2-static target name with SDL2 so the static library can be linked with SDL2::SDL2
	pacmake_textfile_replace("${dir}/source/CMakeLists.txt" "SDL2-static" "SDL2")
	pacmake_textfile_insert("${dir}/source/CMakeLists.txt" 1102 "#")#comment IBUS dependency
	pacmake_textfile_replace("${dir}/source/CMakeLists.txt" "target_link_libraries(SDL2 " "target_link_libraries(SDL2 PRIVATE ")
endfunction(pacmake_patch_preconfigure)

function(pacmake_patch_prebuild package version dir)
endfunction(pacmake_patch_prebuild)

function(pacmake_patch_postbuild package version dir)
endfunction(pacmake_patch_postbuild)

function(pacmake_patch_postinstall package version dir)
endfunction(pacmake_patch_postinstall)
