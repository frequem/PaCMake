pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir sourcedir package version)
	#replace SDL2-static target name with SDL2 so the static library can be linked with SDL2::SDL2
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "SDL2-static" "SDL2")
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 1102 "#")#comment IBUS dependency
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "target_link_libraries(SDL2 " "target_link_libraries(SDL2 PRIVATE ")
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "\$<INSTALL_INTERFACE:include/SDL2>" "\$<INSTALL_INTERFACE:include/SDL2> \$<INSTALL_INTERFACE:include>")
	
	#fix android build		
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 1867
		"\n"
		"if(ANDROID)\n"
		"  include(AndroidNdkModules)\n"
        "  android_ndk_import_module_cpufeatures()\n"
		"  target_link_libraries(SDL2 PUBLIC hidapi cpufeatures)\n"
		"  set(_INSTALL_LIBS hidapi cpufeatures \${_INSTALL_LIBS})\n"
		"endif()\n"
		"\n"
	)
	
	
	
endfunction(pacmake_patch)
