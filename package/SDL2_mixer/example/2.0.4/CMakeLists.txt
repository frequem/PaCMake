cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(sdl2_mixer_example C CXX)

pacmake_add_package(SDL2_mixer VERSION 2.0.4)

add_executable(${PROJECT_NAME} "main.cpp")
target_link_libraries(${PROJECT_NAME} PUBLIC SDL2_mixer::SDL2_mixer)
