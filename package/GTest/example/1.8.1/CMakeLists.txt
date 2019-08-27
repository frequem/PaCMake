cmake_minimum_required(VERSION 3.0.2)

include("../../../../PaCMake.cmake")

project(gtest_example C CXX)

pacmake_add_package(GTest VERSION 1.8.1)

add_executable(${PROJECT_NAME} "main.cpp")
target_link_libraries(${PROJECT_NAME} PUBLIC GTest::gtest)
target_link_libraries(${PROJECT_NAME} PUBLIC GTest::gmock)
