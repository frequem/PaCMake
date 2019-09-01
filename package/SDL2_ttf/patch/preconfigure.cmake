pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir sourcedir package version)
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "target_link_libraries(SDL2_ttf " "target_link_libraries(SDL2_ttf PUBLIC ")
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "Freetype::Freetype" "freetype")
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "Freetype" "freetype")
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 25 "target_include_directories(SDL2_ttf PUBLIC \$<INSTALL_INTERFACE:\${CMAKE_INSTALL_INCLUDEDIR}>)\n#")
endfunction(pacmake_patch)
