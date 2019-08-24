cmake_minimum_required(VERSION 3.0.2)

project(bzip2 VERSION @@@___VERSION___@@@ LANGUAGES C)

set(bzip2_lib_SRCS blocksort.c huffman.c crctable.c randtable.c compress.c decompress.c bzlib.c)
set(bzip2_lib_HDRS bzlib.h bzlib_private.h)
set(bzip2_scripts bzdiff bzgrep bzmore)
set(bzip2_docs bzip2.txt manual.pdf)
set(bzip2_html manual.html)

add_library(${PROJECT_NAME} ${bzip2_lib_SRCS} ${bzip2_lib_HDRS})
set_target_properties(${PROJECT_NAME} PROPERTIES
	SOVERSION ${PROJECT_VERSION}
	VERSION ${PROJECT_VERSION_MAJOR}
	PUBLIC_HEADER bzlib.h
)

include(GNUInstallDirs)
if(NOT WIN32)
	install(PROGRAMS ${bzip2_scripts} DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()
file(GLOB man1 ${${PROJECT_NAME}_SOURCE_DIR}/*.1)
install(FILES ${man1}          DESTINATION share/man/man1)
install(FILES ${bzip2_docs}    DESTINATION doc)
install(FILES ${bzip2_html}    DESTINATION doc/html)

include(CMakePackageConfigHelpers)
write_basic_package_version_file("${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
	VERSION ${PROJECT_VERSION}
	COMPATIBILITY AnyNewerVersion
)

install(
	TARGETS ${PROJECT_NAME}
	EXPORT ${PROJECT_NAME}Targets
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
	INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
	PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(
	EXPORT ${PROJECT_NAME}Targets
	FILE ${PROJECT_NAME}Config.cmake
	NAMESPACE "${PROJECT_NAME}::"
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
)
