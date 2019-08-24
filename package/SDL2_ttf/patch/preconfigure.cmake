pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir workdir package version)
	pacmake_textfile_replace("${workdir}/source/CMakeLists.txt" "target_link_libraries(SDL2_ttf " "target_link_libraries(SDL2_ttf PUBLIC ")
endfunction(pacmake_patch)
