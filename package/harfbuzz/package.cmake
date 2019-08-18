pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(harfbuzz 2.6.0)

pacmake_register_package(
	harfbuzz
	VERSION 2.6.0
	URL "https://github.com/harfbuzz/harfbuzz/archive/2.6.0.tar.gz"
	URL_HASH "SHA256=f766bd507e1e0f5685d57594fdf5aa9623e1d3ef9f0f2c8f8f81cd77ff21f384"
	CMAKE_ARGS "-DHB_BUILD_TESTS=OFF" "-DSKIP_INSTALL_LIBRARIES=ON" #skip installing then patch correct install
	PATCH harfbuzz
)
