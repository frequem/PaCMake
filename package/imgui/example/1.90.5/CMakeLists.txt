cmake_minimum_required(VERSION 3.5)

include("../../../../PaCMake.cmake")

project(imgui_example LANGUAGES CXX)

pacmake_add_package(imgui 1.90.5)

add_executable(${PROJECT_NAME} "main.cpp")
target_link_libraries(${PROJECT_NAME} PUBLIC imgui::imgui)
