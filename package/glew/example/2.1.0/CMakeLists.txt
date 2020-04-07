cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(glew_example C)

pacmake_add_package(glew VERSION 2.1.0)

add_executable(${PROJECT_NAME} "main.c")
target_link_libraries(${PROJECT_NAME} PUBLIC GLEW::glew)
