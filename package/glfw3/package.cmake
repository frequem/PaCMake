pacmake_register_package(
	3.3.8
	SOURCES URL "https://github.com/glfw/glfw/archive/3.3.8.tar.gz" URL_HASH "SHA256=f30f42e05f11e5fc62483e513b0488d5bceeab7d9c5da0ffe2252ad81816c713"
	CMAKE_ARGS "-DGLFW_BUILD_TESTS=OFF" "-DGLFW_BUILD_EXAMPLES=OFF" "-DGLFW_BUILD_DOCS=OFF"
)
