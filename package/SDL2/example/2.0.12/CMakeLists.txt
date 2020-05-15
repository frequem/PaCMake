cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(sdl2_example C CXX)

pacmake_add_package(SDL2 VERSION 2.0.12)

add_executable(${PROJECT_NAME} "main.cpp")
target_link_libraries(${PROJECT_NAME} PUBLIC SDL2::SDL2)
