pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(libpng 1.6.37)

pacmake_register_package(
	libpng
	VERSION 1.6.37
	URL "https://download.sourceforge.net/libpng/libpng-1.6.37.tar.gz"
	URL_HASH "SHA256=daeb2620d829575513e35fecc83f0d3791a620b9b93d800b763542ece9390fb4"
	DEPENDENCIES zlib
	CMAKE_ARGS "-DPNG_TESTS=OFF"
)
