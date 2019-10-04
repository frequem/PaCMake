cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(glfw_example C)

find_package(OpenGL REQUIRED)
pacmake_add_package(glfw STATIC VERSION 3.3)

add_executable(${PROJECT_NAME} "main.c")
target_link_libraries(${PROJECT_NAME} PUBLIC OpenGL::GL glfw)
