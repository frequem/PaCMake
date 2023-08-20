pacmake_include(textfile)

function(pacmake_patch packageName packageVersion workingDirectory)
	pacmake_textfile_replace("${workingDirectory}/CMakeLists.txt" "find_package(ZLIB REQUIRED)" "find_package(zlib REQUIRED NO_PACKAGE_ROOT_PATH NO_CMAKE_ENVIRONMENT_PATH NO_SYSTEM_ENVIRONMENT_PATH NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PATH NO_CMAKE_INSTALL_PREFIX NO_CMAKE_SYSTEM_PACKAGE_REGISTRY NO_CMAKE_FIND_ROOT_PATH)")
	pacmake_textfile_replace("${workingDirectory}/CMakeLists.txt" "include_directories(\${ZLIB_INCLUDE_DIRS})" "get_target_property(ZLIB_INCLUDE_DIRS zlib::zlib INTERFACE_INCLUDE_DIRECTORIES)")
	pacmake_textfile_replace("${workingDirectory}/CMakeLists.txt" "\${ZLIB_LIBRARIES}" "zlib::zlib")

	pacmake_textfile_replace("${workingDirectory}/CMakeLists.txt" "option(PNG_SHARED" "#option(PNG_SHARED")
	pacmake_textfile_replace("${workingDirectory}/CMakeLists.txt" "option(PNG_STATIC" "#option(PNG_STATIC")
	
	pacmake_textfile_replace("${workingDirectory}/CMakeLists.txt" "if(PNG_SHARED)" "if(BUILD_SHARED_LIBS)")
	pacmake_textfile_replace("${workingDirectory}/CMakeLists.txt" "if(PNG_STATIC)" "if(NOT BUILD_SHARED_LIBS)")
	
	pacmake_textfile_replace("${workingDirectory}/CMakeLists.txt" "png_shared" "png")
	pacmake_textfile_replace("${workingDirectory}/CMakeLists.txt" "png_static" "png")
	
	pacmake_textfile_replace("${workingDirectory}/CMakeLists.txt" "target_link_libraries(png " "target_include_directories(png PUBLIC \$<INSTALL_INTERFACE:include>)\n  target_link_libraries(png ")
	
	pacmake_textfile_replace("${workingDirectory}/CMakeLists.txt" "install(EXPORT libpng" "set_target_properties(png PROPERTIES EXPORT_NAME libpng)\n  install(EXPORT libpng")
	
	pacmake_textfile_replace("${workingDirectory}/CMakeLists.txt" "FILE lib\${PNG_LIB_NAME}.cmake" "FILE libpngConfig.cmake\n          NAMESPACE \"\${PROJECT_NAME}::\"") # 1.6.39
	pacmake_textfile_replace("${workingDirectory}/CMakeLists.txt" "FILE libpng\${PNGLIB_ABI_VERSION}.cmake" "FILE libpngConfig.cmake\n          NAMESPACE \"\${PROJECT_NAME}::\"") # 1.6.40
	
	file(APPEND "${workingDirectory}/CMakeLists.txt"
		"\n"
		"include(CMakePackageConfigHelpers)\n"
		"write_basic_package_version_file(\"\${CMAKE_BINARY_DIR}/\${PROJECT_NAME}ConfigVersion.cmake\"\n"
		"\tVERSION \${PNGLIB_VERSION}\n"
		"\tCOMPATIBILITY AnyNewerVersion\n"
		")\n"
		"\n"
		"install(\n"
		"\tFILES\n"
		"\t\"\${CMAKE_BINARY_DIR}/\${PROJECT_NAME}ConfigVersion.cmake\"\n"
		"\tDESTINATION \"\${CMAKE_INSTALL_LIBDIR}/\${PROJECT_NAME}\"\n"
		")\n"
	)
endfunction(pacmake_patch)
