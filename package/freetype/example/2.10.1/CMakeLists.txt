cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(freetype_example C)

pacmake_add_package(freetype VERSION 2.10.1)

add_executable(${PROJECT_NAME} "main.c")
target_link_libraries(${PROJECT_NAME} PUBLIC freetype)
