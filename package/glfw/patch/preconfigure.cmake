pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir sourcedir package version)
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 316 "set(GLFW_CONFIG_PATH \"\${CMAKE_INSTALL_LIBDIR}/cmake/glfw\")\n#")
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 320 "                              src/glfwConfig.cmake\n#")
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 325 "write_basic_package_version_file(src/glfwConfigVersion.cmake\n#")
	pacmake_textfile_insert("${sourcedir}/CMakeLists.txt" 332 "configure_file(src/glfw3.pc.in src/glfw.pc @ONLY)\n#")
	
	pacmake_textfile_replace("${sourcedir}/CMakeLists.txt" "\${GLFW_BINARY_DIR}/src/glfw3" "\${GLFW_BINARY_DIR}/src/glfw")
	
endfunction(pacmake_patch)
