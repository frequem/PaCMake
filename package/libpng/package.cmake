pacmake_register_package(
	1.6.40 FINAL
	SOURCES URL "https://download.sourceforge.net/libpng/libpng-1.6.40.tar.gz" URL_HASH "SHA256=8f720b363aa08683c9bf2a563236f45313af2c55d542b5481ae17dd8d183bb42"
	DEPENDENCIES zlib 1.2.13
	CMAKE_ARGS "-DPNG_EXECUTABLES=OFF" "-DPNG_TESTS=OFF"
)
