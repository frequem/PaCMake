cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(sdl2_ttf_example C CXX)

pacmake_add_package(SDL2_ttf STATIC VERSION 2.0.15)

add_executable(${PROJECT_NAME} "main.cpp")
target_link_libraries(${PROJECT_NAME} PUBLIC SDL2_ttf::SDL2_ttf)
