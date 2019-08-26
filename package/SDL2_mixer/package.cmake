pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(SDL2_mixer 2.0.4)

pacmake_register_package(
	SDL2_mixer
	VERSION 2.0.4
	URL "https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.4.tar.gz"
	URL_HASH "SHA256=b4cf5a382c061cd75081cf246c2aa2f9df8db04bdda8dcdc6b6cca55bede2419"
	DEPENDENCIES SDL2 modplug
)
