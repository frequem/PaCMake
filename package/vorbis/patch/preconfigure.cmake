pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir sourcedir package version)
	file(WRITE "${sourcedir}/lib/vorbisConfig.cmake"
		"include(CMakeFindDependencyMacro)\n"
		"find_dependency(libogg)\n"
		"include(\"\${CMAKE_CURRENT_LIST_DIR}/vorbisTargets.cmake\")\n"
	)
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 66 "find_package(libogg REQUIRED)\n")
	pacmake_textfile_remove("${sourcedir}/CMakeLists.txt" 55 11)
	
	pacmake_textfile_remove("${sourcedir}/lib/CMakeLists.txt" 71 1)
	pacmake_textfile_replace("${sourcedir}/lib/CMakeLists.txt" "vorbis \${OGG_LIBRARIES}" "vorbis PUBLIC libogg::ogg")
	pacmake_textfile_replace("${sourcedir}/lib/CMakeLists.txt" "\${OGG_LIBRARIES}" "PUBLIC")
	
	pacmake_textfile_replace("${sourcedir}/lib/CMakeLists.txt" "RUNTIME DESTINATION" "EXPORT vorbisTargets INCLUDES DESTINATION \${CMAKE_INSTALL_FULL_INCLUDEDIR} RUNTIME DESTINATION")
	
	pacmake_textfile_insert("${sourcedir}/lib/CMakeLists.txt" 93
		"\n"
		"    install(EXPORT vorbisTargets FILE vorbisTargets.cmake NAMESPACE \"vorbis::\" DESTINATION \"\${CMAKE_INSTALL_LIBDIR}/cmake/vorbis\")\n"
	)
	
	pacmake_textfile_insert("${sourcedir}/lib/CMakeLists.txt" 93
		"\n"
		"    install(FILES \"\${CMAKE_CURRENT_SOURCE_DIR}/vorbisConfig.cmake\" DESTINATION \"\${CMAKE_INSTALL_LIBDIR}/cmake/vorbis\")\n"
	)
endfunction(pacmake_patch)
