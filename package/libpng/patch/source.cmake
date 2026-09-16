pacmake_include(textfile)

function(pacmake_patch packageName packageVariant packageVersion workingDirectory)
	pacmake_textfile_replace("${workingDirectory}/CMakeLists.txt" "${workingDirectory}/CMakeLists.txt"
		STRING
		"cmake_minimum_required(VERSION 3.1)" "cmake_minimum_required(VERSION 3.10)"
		"cmake_policy(VERSION 3.1)" "cmake_policy(VERSION 3.10)"
		"find_package(ZLIB REQUIRED)" "find_package(zlib REQUIRED)"
		"include_directories(\${ZLIB_INCLUDE_DIRS})" "get_target_property(ZLIB_INCLUDE_DIRS zlib::zlib INTERFACE_INCLUDE_DIRECTORIES)"
		"\${ZLIB_LIBRARIES}" "zlib::zlib"
		"option(PNG_SHARED" "# option(PNG_SHARED"
		"option(PNG_STATIC" "# option(PNG_STATIC"
		"if(PNG_SHARED)" "if(BUILD_SHARED_LIBS)"
		"if(PNG_STATIC)" "if(NOT BUILD_SHARED_LIBS)"
		"png_shared" "png"
		"png_static" "png"
		"target_link_libraries(png " "target_include_directories(png PUBLIC \$<INSTALL_INTERFACE:include>)\n  target_link_libraries(png "
		"install(EXPORT libpng" "set_target_properties(png PROPERTIES EXPORT_NAME libpng)\n  install(EXPORT libpng"
		"FILE lib\${PNG_LIB_NAME}.cmake" "FILE libpngConfig.cmake\n          NAMESPACE \"\${PROJECT_NAME}::\"" # 1.6.39
		"FILE libpng\${PNGLIB_ABI_VERSION}.cmake" "FILE libpngConfig.cmake\n          NAMESPACE \"\${PROJECT_NAME}::\"" # 1.6.40
	)

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
