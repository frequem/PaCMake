pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(freetype 2.10.1)

pacmake_register_package(
	freetype
	VERSION 2.10.1
	URL "https://download.savannah.gnu.org/releases/freetype/freetype-2.10.1.tar.gz"
	URL_HASH "SHA256=3a60d391fd579440561bf0e7f31af2222bc610ad6ce4d9d7bd2165bca8669110"
	DEPENDENCIES libpng zlib
	CMAKE_ARGS "-DFT_WITH_ZLIB=ON" "-DFT_WITH_PNG=ON"
	PATCH freetype
)
