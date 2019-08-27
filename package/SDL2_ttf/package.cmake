pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(SDL2_ttf 2.0.15)

pacmake_register_package(
	SDL2_ttf
	VERSION 2.0.15
	URL "https://hg.libsdl.org/SDL_ttf/archive/049abc1f36b5.tar.gz"
	URL_HASH "SHA256=41babf417e9abd067ca80063ca141133d6a0f9484c7511db0edb22f75da8d57e"
	DEPENDENCIES SDL2 freetype
)
