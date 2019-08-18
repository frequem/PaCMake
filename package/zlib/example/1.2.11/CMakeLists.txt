cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(zlib_example C)

pacmake_add_package(zlib VERSION 1.2.11)

add_executable(${PROJECT_NAME} "main.c")
target_link_libraries(${PROJECT_NAME} PUBLIC zlib::zlib)
