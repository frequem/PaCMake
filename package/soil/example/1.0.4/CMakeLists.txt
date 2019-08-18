cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(soil_example C CXX)

pacmake_add_package(soil VERSION 1.0.4)

add_executable(${PROJECT_NAME} "main.c")
target_link_libraries(${PROJECT_NAME} PUBLIC soil::soil)
