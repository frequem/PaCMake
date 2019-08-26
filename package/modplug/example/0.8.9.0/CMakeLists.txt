cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(modplug_example CXX)

pacmake_add_package(modplug VERSION 0.8.9.0)

add_executable(${PROJECT_NAME} "main.cpp")
target_link_libraries(${PROJECT_NAME} PUBLIC modplug::modplug)
