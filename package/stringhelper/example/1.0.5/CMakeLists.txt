cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(stringhelper_example C CXX)

pacmake_add_package(stringhelper VERSION 1.0.5)

add_executable(${PROJECT_NAME} "main.c")
target_link_libraries(${PROJECT_NAME} PUBLIC stringhelper::stringhelper)
