pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(glfw 3.3)

pacmake_register_package(
	glfw
	VERSION 3.3
	URL "https://github.com/glfw/glfw/archive/3.3.tar.gz"
	URL_HASH "SHA256=81bf5fde487676a8af55cb317830703086bb534c53968d71936e7b48ee5a0f3e"
	CMAKE_ARGS "-DGLFW_BUILD_TESTS=OFF" "-DGLFW_BUILD_EXAMPLES=OFF" "-DGLFW_BUILD_DOCS=OFF"
)
