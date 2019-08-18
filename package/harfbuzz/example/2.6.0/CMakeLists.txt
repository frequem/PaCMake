cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(harfbuzz_example C)

pacmake_add_package(harfbuzz VERSION 2.6.0)

add_executable(${PROJECT_NAME} "main.c")
target_link_libraries(${PROJECT_NAME} PUBLIC harfbuzz::harfbuzz)
