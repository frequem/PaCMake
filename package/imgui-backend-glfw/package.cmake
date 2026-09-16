pacmake_register_package(
	1.92.8 FINAL
	SOURCES NO_SOURCE
	DEPENDENCIES imgui 1.92.8 glfw3 3.4
)

pacmake_register_package(
	VARIANT docking 1.92.8 FINAL
	SOURCES NO_SOURCE
	DEPENDENCIES imgui::docking 1.92.8 glfw3 3.4
)
