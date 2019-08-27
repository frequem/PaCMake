pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(vorbis 1.3.6)

pacmake_register_package(
	vorbis
	VERSION 1.3.6
	URL "https://github.com/xiph/vorbis/archive/v1.3.6.tar.gz"
	URL_HASH "SHA256=43fc4bc34f13da15b8acfa72fd594678e214d1cab35fc51d3a54969a725464eb"
	DEPENDENCIES libogg
)
