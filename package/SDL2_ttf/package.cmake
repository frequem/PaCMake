pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(SDL2_ttf 2.0.15)

pacmake_register_package(
	SDL2_ttf
	VERSION 2.0.15
	HG_REPOSITORY "https://hg.libsdl.org/SDL_ttf/"
	HG_TAG "release-2.0.15"
	DEPENDENCIES SDL2 freetype
	PATCH SDL2_ttf
)
