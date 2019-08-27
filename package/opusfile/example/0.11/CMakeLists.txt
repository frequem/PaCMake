cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(opusfile_example CXX)

pacmake_add_package(opusfile VERSION 0.11)

add_executable(${PROJECT_NAME} "main.cpp")
target_link_libraries(${PROJECT_NAME} PUBLIC opusfile::opusfile)
