pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir workdir package version)
	#replace SDL2-static target name with SDL2 so the static library can be linked with SDL2::SDL2
	pacmake_textfile_replace("${workdir}/source/CMakeLists.txt" "SDL2-static" "SDL2")
	pacmake_textfile_insert("${workdir}/source/CMakeLists.txt" 1102 "#")#comment IBUS dependency
	pacmake_textfile_replace("${workdir}/source/CMakeLists.txt" "target_link_libraries(SDL2 " "target_link_libraries(SDL2 PRIVATE ")
endfunction(pacmake_patch)
