cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(ogg_example CXX)

pacmake_add_package(libogg VERSION 1.3.3)

add_executable(${PROJECT_NAME} "main.cpp")
target_link_libraries(${PROJECT_NAME} PUBLIC libogg::ogg)
