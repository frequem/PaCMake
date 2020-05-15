pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(SDL2 2.0.12)

pacmake_register_package(
	SDL2
	VERSION 2.0.12
	URL "https://www.libsdl.org/release/SDL2-2.0.12.tar.gz"
	URL_HASH "SHA256=349268f695c02efbc9b9148a70b85e58cefbbf704abd3e91be654db7f1e2c863"
	CMAKE_ARGS "-DSDL_STATIC_PIC=ON"
)

#broken since GCC 10 (multiple defintions)
pacmake_register_package(
	SDL2
	VERSION 2.0.10
	URL "https://www.libsdl.org/release/SDL2-2.0.10.tar.gz"
	URL_HASH "SHA256=b4656c13a1f0d0023ae2f4a9cf08ec92fffb464e0f24238337784159b8b91d57"
	CMAKE_ARGS "-DSDL_STATIC_PIC=ON"
)
