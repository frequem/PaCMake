cmake_minimum_required(VERSION 3.0.2)

project(opusfile VERSION @@@___VERSION___@@@ LANGUAGES C)

find_package(Opus REQUIRED)
find_package(libogg REQUIRED)

option(OPUSFILE_ENABLE_ASSERTIONS "Enable assertions in code" ON)
option(OPUSFILE_FIXED_POINT "Enable Fixed Point API" OFF)
option(OPUSFILE_DISABLE_FLOAT "Disable float API" OFF)

set(SOURCES
	include/opusfile.h
	src/http.c
	src/info.c
	src/internal.c
	src/internal.h
	src/opusfile.c
	src/stream.c
	src/wincerts.c
	src/winerrno.h
)

add_library(${PROJECT_NAME} ${SOURCES})

include(GNUInstallDirs)

target_include_directories(${PROJECT_NAME} PUBLIC 
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
	$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/opus>
)
target_link_libraries(${PROJECT_NAME} PUBLIC Opus::opus libogg::ogg m)


include(CheckSymbolExists)
check_symbol_exists(lrint math.h HAVE_LRINT)
check_symbol_exists(lrintf math.h HAVE_LRINTF)

if(HAVE_LRINT)
	target_compile_definitions(${PROJECT_NAME} PRIVATE HAVE_LRINT)
endif()
if(HAVE_LRINTF)
	target_compile_definitions(${PROJECT_NAME} PRIVATE HAVE_LRINTF)
endif()

if(OPUSFILE_ENABLE_ASSERTIONS)
	target_compile_definitions(${PROJECT_NAME} PRIVATE OP_ENABLE_ASSERTIONS)
endif()
if(OPUSFILE_FIXED_POINT)
	target_compile_definitions(${PROJECT_NAME} PRIVATE OP_FIXED_POINT)
endif()
if(OPUSFILE_DISABLE_FLOAT)
	target_compile_definitions(${PROJECT_NAME} PRIVATE OP_DISABLE_FLOAT_API)
endif()

install(
	FILES include/opusfile.h
	DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/opus
)

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
)

install(
	FILES
		"${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}Config.cmake"
		"${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
)

install(
	EXPORT ${PROJECT_NAME}Targets
	FILE ${PROJECT_NAME}Targets.cmake
	NAMESPACE "${PROJECT_NAME}::"
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
)
