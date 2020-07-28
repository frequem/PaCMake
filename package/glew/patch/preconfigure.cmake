pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir sourcedir package version)
	file(WRITE "${sourcedir}/CMakeLists.txt"
		"cmake_minimum_required(VERSION 2.8.12)\n"
		"add_subdirectory(build/cmake)\n"
		"project(glew_dummy)\n"
	)
	pacmake_textfile_replace("${sourcedir}/build/cmake/CMakeLists.txt" "WIN32 AND MSVC AND" "BUILD_SHARED_LIBS AND WIN32 AND MSVC AND")
	pacmake_textfile_replace("${sourcedir}/build/cmake/CMakeLists.txt" "glew_s" "glew")
	
	pacmake_textfile_remove("${sourcedir}/build/cmake/CMakeLists.txt" 146 8)
	pacmake_textfile_insert("${sourcedir}/build/cmake/CMakeLists.txt" 146 "set(targets_to_install glew)\n")
	
	pacmake_textfile_remove("${sourcedir}/build/cmake/CMakeLists.txt" 139 4)
	
	pacmake_textfile_insert("${sourcedir}/build/cmake/CMakeLists.txt" 139
		"  if(NOT BUILD_SHARED_LIBS)\n"
		"    target_compile_definitions(glew INTERFACE \"GLEW_STATIC\")\n"
		"  endif()\n"
		"  target_include_directories(glew PUBLIC \$<INSTALL_INTERFACE:include>)\n"
	)
	
	pacmake_textfile_remove("${sourcedir}/build/cmake/CMakeLists.txt" 133 2)
	
	pacmake_textfile_insert("${sourcedir}/build/cmake/CMakeLists.txt" 133
		"if(BUILD_SHARED_LIBS)\n"
		"  target_link_libraries (glew LINK_PUBLIC \${GLEW_LIBRARIES})\n"
		"else()\n"
		"  target_link_libraries (glew \${GLEW_LIBRARIES})\n"
		"endif()\n"
	)
	
	pacmake_textfile_remove("${sourcedir}/build/cmake/CMakeLists.txt" 120 1)
	pacmake_textfile_insert("${sourcedir}/build/cmake/CMakeLists.txt" 120
		"if(BUILD_SHARED_LIBS AND BUILD_FRAMEWORK)\n"
	)
	pacmake_textfile_insert("${sourcedir}/build/cmake/CMakeLists.txt" 118 "  endif()\n")
	pacmake_textfile_insert("${sourcedir}/build/cmake/CMakeLists.txt" 117 "  if(BUILD_SHARED_LIBS)\n    ")
	
	pacmake_textfile_remove("${sourcedir}/build/cmake/CMakeLists.txt" 116 1)
	
	
	pacmake_textfile_insert("${sourcedir}/build/cmake/CMakeLists.txt" 111 "  endif()\n")
	pacmake_textfile_insert("${sourcedir}/build/cmake/CMakeLists.txt" 110 "  if(BUILD_SHARED_LIBS)\n    ")
	
	pacmake_textfile_remove("${sourcedir}/build/cmake/CMakeLists.txt" 108 1)
	
	pacmake_textfile_insert("${sourcedir}/build/cmake/CMakeLists.txt" 106 "  endif()\n")
	pacmake_textfile_insert("${sourcedir}/build/cmake/CMakeLists.txt" 105 "  endif()\n  if(BUILD_SHARED_LIBS)\n    ")
	pacmake_textfile_insert("${sourcedir}/build/cmake/CMakeLists.txt" 104 "  else()\n    ")
	pacmake_textfile_insert("${sourcedir}/build/cmake/CMakeLists.txt" 103 "  if(BUILD_SHARED_LIBS)\n    ")
	
	
	pacmake_textfile_insert("${sourcedir}/build/cmake/CMakeLists.txt" 100 "endif()\n")
	pacmake_textfile_insert("${sourcedir}/build/cmake/CMakeLists.txt" 99 "  ")
	pacmake_textfile_insert("${sourcedir}/build/cmake/CMakeLists.txt" 98 "else()\n  ")
	pacmake_textfile_insert("${sourcedir}/build/cmake/CMakeLists.txt" 95 "  ")
	pacmake_textfile_insert("${sourcedir}/build/cmake/CMakeLists.txt" 94 "if(BUILD_SHARED_LIBS)\n  ")
	
	pacmake_textfile_replace("${sourcedir}/build/cmake/CMakeLists.txt" "WIN32 AND MSVC" "BUILD_SHARED_LIBS AND WIN32 AND MSVC")
endfunction(pacmake_patch)
