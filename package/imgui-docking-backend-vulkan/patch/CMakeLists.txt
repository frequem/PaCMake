cmake_minimum_required(VERSION 3.11)

project(backend-vulkan LANGUAGES CXX VERSION 1.92.8)

file(GLOB SOURCES "*.cpp")
file(GLOB HEADERS "*.h")
add_library(${PROJECT_NAME} ${SOURCES} ${HEADERS})

find_package(imgui-docking REQUIRED)
find_package(Vulkan REQUIRED)
target_link_libraries(${PROJECT_NAME} PUBLIC imgui-docking::imgui Vulkan::Vulkan)

include(GNUInstallDirs)

install(
	TARGETS ${PROJECT_NAME}
	EXPORT "${PROJECT_NAME}Targets"
	LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
	ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
	RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
	INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)

install(
	FILES ${HEADERS}
	DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)

include(CMakePackageConfigHelpers)

write_basic_package_version_file(
	"${CMAKE_BINARY_DIR}/imgui-docking-backend-vulkanConfigVersion.cmake"
	VERSION ${PROJECT_VERSION}
	COMPATIBILITY AnyNewerVersion
)

install(
	FILES "${CMAKE_BINARY_DIR}/imgui-docking-backend-vulkanConfigVersion.cmake"
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/imgui-docking-backend-vulkan"
)

install(
	FILES "${CMAKE_SOURCE_DIR}/imgui-docking-backend-vulkanConfig.cmake"
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/imgui-docking-backend-vulkan"
)

install(
	EXPORT "${PROJECT_NAME}Targets"
	FILE "imgui-docking-backend-vulkanTargets.cmake"
	NAMESPACE "imgui-docking::"
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/imgui-docking-backend-vulkan"
)
