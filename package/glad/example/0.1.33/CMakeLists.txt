cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(glad_example C)

pacmake_add_package(glad VERSION 0.1.33)

add_executable(${PROJECT_NAME} "main.c")
target_link_libraries(${PROJECT_NAME} PUBLIC glad::glad)
