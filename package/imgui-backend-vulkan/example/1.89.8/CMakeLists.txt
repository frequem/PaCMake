cmake_minimum_required(VERSION 3.5)

include("../../../../PaCMake.cmake")

project(imgui-backend-vulkan_example LANGUAGES CXX)

pacmake_add_package(imgui-backend-vulkan 1.89.8)
find_package(Vulkan REQUIRED)

add_executable(${PROJECT_NAME} "main.cpp")
target_link_libraries(${PROJECT_NAME} PUBLIC Vulkan::Vulkan imgui::imgui-backend-vulkan)
