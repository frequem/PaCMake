cmake_minimum_required(VERSION 3.6)

include("../../../../PaCMake.cmake")

project(png_example LANGUAGES C)

pacmake_add_package(libpng 1.6.40)

add_executable(${PROJECT_NAME} "main.c")
target_link_libraries(${PROJECT_NAME} PUBLIC libpng::libpng)
