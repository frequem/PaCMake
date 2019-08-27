pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir sourcedir package version)
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "target_link_libraries(SDL2_ttf " "target_link_libraries(SDL2_ttf PUBLIC ")
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "Freetype::Freetype" "freetype")
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "Freetype" "freetype")
endfunction(pacmake_patch)
