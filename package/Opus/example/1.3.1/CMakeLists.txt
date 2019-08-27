cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(opus_example CXX)

pacmake_add_package(Opus VERSION 1.3.1)

add_executable(${PROJECT_NAME} "main.cpp")
target_link_libraries(${PROJECT_NAME} PUBLIC Opus::opus)
