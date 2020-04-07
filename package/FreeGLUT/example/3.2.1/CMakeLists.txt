cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(freeglut_example C)

pacmake_add_package(FreeGLUT VERSION 3.2.1)

add_executable(${PROJECT_NAME} "main.c")
target_link_libraries(${PROJECT_NAME} PUBLIC FreeGLUT::freeglut)
