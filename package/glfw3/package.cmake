pacmake_register_package(
	3.3.8
	SOURCES URL "https://github.com/glfw/glfw/archive/3.3.8.tar.gz" URL_HASH "SHA256=f30f42e05f11e5fc62483e513b0488d5bceeab7d9c5da0ffe2252ad81816c713"
	CMAKE_ARGS "-DGLFW_BUILD_TESTS=OFF" "-DGLFW_BUILD_EXAMPLES=OFF" "-DGLFW_BUILD_DOCS=OFF"
)

pacmake_register_package(
	3.4
	SOURCES URL "https://github.com/glfw/glfw/archive/3.4.tar.gz" URL_HASH "SHA256=c038d34200234d071fae9345bc455e4a8f2f544ab60150765d7704e08f3dac01"
	CMAKE_ARGS "-DGLFW_BUILD_TESTS=OFF" "-DGLFW_BUILD_EXAMPLES=OFF" "-DGLFW_BUILD_DOCS=OFF"
)
