cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(vorbis_example CXX)

pacmake_add_package(vorbis VERSION 1.3.6)

add_executable(${PROJECT_NAME} "main.cpp")
target_link_libraries(${PROJECT_NAME} PUBLIC vorbis::vorbis)
target_link_libraries(${PROJECT_NAME} PUBLIC vorbis::vorbisfile)
target_link_libraries(${PROJECT_NAME} PUBLIC vorbis::vorbisenc)
