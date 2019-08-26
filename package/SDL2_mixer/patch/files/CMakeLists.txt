cmake_minimum_required(VERSION 3.0.2)

project(SDL2_mixer VERSION @@@___VERSION___@@@)

option(ENABLE_MUSIC_WAVE "ENABLE_MUSIC_WAVE" ON)

find_package(SDL2 REQUIRED)

set(SOURCES
	effect_position.c
	effect_stereoreverse.c
	effects_internal.c
	load_aiff.c
	load_voc.c
	mixer.c
	music.c
	music_cmd.c
	music_flac.c
	music_fluidsynth.c
	music_mad.c
	music_mikmod.c
	music_modplug.c
	music_mpg123.c
	music_nativemidi.c
	music_ogg.c
	music_opus.c
	music_timidity.c
	music_wav.c
)

set(HEADERS
	SDL_mixer.h
	effects_internal.h
	load_aiff.h
	load_voc.h
	mixer.h
	music.h
	music_cmd.h
	music_flac.h
	music_fluidsynth.h
	music_mad.h
	music_mikmod.h
	music_modplug.h
	music_mpg123.h
	music_nativemidi.h
	music_ogg.h
	music_opus.h
	music_timidity.h
	music_wav.h
)

include(GNUInstallDirs)

add_library(${PROJECT_NAME} ${SOURCES} ${HEADERS})
target_include_directories(${PROJECT_NAME} PUBLIC $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/SDL2>)

target_link_libraries(${PROJECT_NAME} PUBLIC SDL2::SDL2)

if(ENABLE_MUSIC_WAVE)
	target_compile_definitions(${PROJECT_NAME} PRIVATE MUSIC_WAV)
endif()

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
	FILES SDL_mixer.h
	DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/SDL2
)

install(
	EXPORT ${PROJECT_NAME}Targets
	FILE ${PROJECT_NAME}Config.cmake
	NAMESPACE "${PROJECT_NAME}::"
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
)

