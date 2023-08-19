cmake_minimum_required(VERSION 3.6)

include("../../../../PaCMake.cmake")

project(zlib_example LANGUAGES C)

pacmake_add_package(zlib 1.2.13)

add_executable(${PROJECT_NAME} "main.c")
target_link_libraries(${PROJECT_NAME} PUBLIC zlib::zlib)
