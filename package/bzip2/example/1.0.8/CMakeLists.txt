cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(bzip2_example C)

pacmake_add_package(bzip2 VERSION 1.0.8)

add_executable(${PROJECT_NAME} "main.c")
target_link_libraries(${PROJECT_NAME} PUBLIC bzip2::bzip2)
