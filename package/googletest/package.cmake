pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(googletest 1.8.1)

pacmake_register_package(
	googletest
	VERSION 1.8.1
	URL "https://github.com/google/googletest/archive/release-1.8.1.tar.gz"
	URL_HASH "SHA256=9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c"
)
