pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(FreeGLUT 3.2.1)

pacmake_register_package(
	FreeGLUT
	VERSION 3.2.1
	URL "https://sourceforge.net/projects/freeglut/files/freeglut/3.2.1/freeglut-3.2.1.tar.gz"
	URL_HASH "SHA256=d4000e02102acaf259998c870e25214739d1f16f67f99cb35e4f46841399da68"
)
