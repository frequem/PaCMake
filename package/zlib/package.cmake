pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(zlib 1.2.11)

pacmake_register_package(
	zlib
	VERSION 1.2.11
	URL "https://www.zlib.net/zlib-1.2.11.tar.gz"
	URL_HASH "SHA256=c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"
)
