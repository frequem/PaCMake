cmake_minimum_required(VERSION 3.0.2)

project(libmodplug VERSION @@@___VERSION___@@@)

set(SOURCES 
	src/libmodplug/it_defs.h
	src/libmodplug/sndfile.h
	src/libmodplug/stdafx.h
	src/fastmix.cpp
	src/load_669.cpp
	src/load_abc.cpp
	src/load_amf.cpp
	src/load_ams.cpp
	src/load_dbm.cpp
	src/load_dmf.cpp
	src/load_dsm.cpp
	src/load_far.cpp
	src/load_it.cpp
	src/load_j2b.cpp
	src/load_mdl.cpp
	src/load_med.cpp
	src/load_mid.cpp
	src/load_mod.cpp
	src/load_mt2.cpp
	src/load_mtm.cpp
	src/load_okt.cpp
	src/load_pat.cpp
	src/load_pat.h
	src/load_psm.cpp
	src/load_ptm.cpp
	src/load_s3m.cpp
	src/load_stm.cpp
	src/load_ult.cpp
	src/load_umx.cpp
	src/load_wav.cpp
	src/load_xm.cpp
	src/mmcmp.cpp
	src/modplug.cpp
	src/modplug.h
	src/snd_dsp.cpp
	src/snd_flt.cpp
	src/snd_fx.cpp
	src/sndfile.cpp
	src/sndmix.cpp
	src/tables.h
)

add_library(${PROJECT_NAME} ${SOURCES})
target_include_directories(${PROJECT_NAME} PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/libmodplug>)
target_compile_definitions(${PROJECT_NAME} PRIVATE MODPLUG_BUILD)

if(UNIX)
	target_link_libraries(${PROJECT_NAME} PUBLIC m)
endif()

if(WIN32)
	target_compile_definitions(${PROJECT_NAME} PRIVATE _USE_MATH_DEFINES)
	target_compile_definitions(${PROJECT_NAME} PRIVATE NOMINMAX)
endif()

include (CheckIncludeFile)

if(WIN32 AND NOT (MINGW OR MSYS))
	set(MSINTTYPES_PATH "$ENV{MSINTTYPES_PATH}" CACHE PATH "search path for inttypes.h and stdint.h")

	find_path(STDINT_INCLUDE_DIR
		stdint.h
		PATHS
		${MSINTTYPES_PATH}
    )

	if(STDINT_INCLUDE_DIR)
		target_compile_definitions(${PROJECT_NAME} PRIVATE HAVE_STDINT_H)
		target_include_directories(${PROJECT_NAME} PRIVATE "${STDINT_INCLUDE_DIR}")
	endif()

	find_path(INTTYPES_INCLUDE_DIR
		inttypes.h
		PATHS
		${MSINTTYPES_PATH}
	)

	if(INTTYPES_INCLUDE_DIR)
		target_compile_definitions(${PROJECT_NAME} PRIVATE HAVE_INTTYPES_H)
		target_include_directories(${PROJECT_NAME} PRIVATE "${INTTYPES_INCLUDE_DIR}")
	endif()

	if(NOT STDINT_INCLUDE_DIR OR NOT INTTYPES_INCLUDE_DIR)
		message(WARNING
			"Compilation may fail if inttypes.h is not natively supported by the compiler."
			"You can get inttypes.h from http://code.google.com/p/msinttypes/"
		)
	endif()
else()
	check_include_file("stdint.h" HAVE_STDINT)
	if(HAVE_STDINT)
		target_compile_definitions(${PROJECT_NAME} PRIVATE HAVE_STDINT_H)
	endif()
endif()

include(CheckCXXSymbolExists)

check_cxx_symbol_exists(setenv stdlib.h HAVE_SETENV)
check_cxx_symbol_exists(sinf math.h HAVE_SINF)

if(HAVE_SETENV)
	target_compile_definitions(${PROJECT_NAME} PRIVATE HAVE_SETENV)
endif()

if(HAVE_SINF)
	target_compile_definitions(${PROJECT_NAME} PRIVATE HAVE_SINF)
endif()

if(BUILD_SHARED_LIBS)
	target_compile_definitions(${PROJECT_NAME} PRIVATE DLL_EXPORT)
else()
	target_compile_definitions(${PROJECT_NAME} PRIVATE MODPLUG_STATIC)
endif()

include(GNUInstallDirs)

include(CMakePackageConfigHelpers)
write_basic_package_version_file("${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
	VERSION ${PROJECT_VERSION}
	COMPATIBILITY AnyNewerVersion
)

install(FILES
	src/libmodplug/it_defs.h
	src/libmodplug/sndfile.h
	src/libmodplug/stdafx.h
	src/modplug.h
	DESTINATION
	${CMAKE_INSTALL_INCLUDEDIR}/libmodplug
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
	EXPORT ${PROJECT_NAME}Targets
	FILE ${PROJECT_NAME}Config.cmake
	NAMESPACE "${PROJECT_NAME}::"
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
)
