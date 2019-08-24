pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(glew 2.1.0)

pacmake_register_package(
	glew
	VERSION 2.1.0
	URL "https://sourceforge.net/projects/glew/files/glew/2.1.0/glew-2.1.0.tgz"
	URL_HASH "SHA256=04de91e7e6763039bc11940095cd9c7f880baba82196a7765f727ac05a993c95"
)
