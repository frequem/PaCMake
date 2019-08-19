cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(glm_example CXX)

pacmake_add_package(glm VERSION 0.9.9.5)

add_executable(${PROJECT_NAME} "main.cpp")
target_link_libraries(${PROJECT_NAME} PUBLIC glm)
