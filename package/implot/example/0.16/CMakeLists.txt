cmake_minimum_required(VERSION 3.5)

include("../../../../PaCMake.cmake")

project(implot_example LANGUAGES CXX)

pacmake_add_package(implot 0.16)

add_executable(${PROJECT_NAME} "main.cpp")
target_link_libraries(${PROJECT_NAME} PUBLIC implot::implot)
