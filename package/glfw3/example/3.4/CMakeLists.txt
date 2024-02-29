cmake_minimum_required(VERSION 3.5)

include("../../../../PaCMake.cmake")

project(glfw_example LANGUAGES C)

set(OpenGL_GL_PREFERENCE GLVND)
find_package(OpenGL REQUIRED)
pacmake_add_package(glfw3 3.4)

add_executable(${PROJECT_NAME} "main.c")
target_link_libraries(${PROJECT_NAME} PUBLIC OpenGL::GL glfw)
