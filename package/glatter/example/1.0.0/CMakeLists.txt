cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(glatter_example C)

pacmake_add_package(glatter VERSION 1.0.0)

add_executable(${PROJECT_NAME} "main.c")
target_link_libraries(${PROJECT_NAME} PUBLIC glatter::glatter)
