pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(SDL2 2.0.10)

pacmake_register_package(
	SDL2
	VERSION 2.0.10
	URL "https://www.libsdl.org/release/SDL2-2.0.10.tar.gz"
	URL_HASH "SHA256=b4656c13a1f0d0023ae2f4a9cf08ec92fffb464e0f24238337784159b8b91d57"
	PATCH SDL2
)
