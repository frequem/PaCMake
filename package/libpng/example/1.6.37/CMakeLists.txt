cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(png_example C)

pacmake_add_package(libpng VERSION 1.6.37)

add_executable(${PROJECT_NAME} "main.c")
target_link_libraries(${PROJECT_NAME} PUBLIC png)
