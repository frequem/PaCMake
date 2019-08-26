pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir sourcedir package version)
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "target_link_libraries(SDL2_ttf " "target_link_libraries(SDL2_ttf PUBLIC ")
endfunction(pacmake_patch)
