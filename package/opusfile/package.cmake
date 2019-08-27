pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(opusfile 0.11)

pacmake_register_package(
	opusfile
	VERSION 0.11
	URL "https://ftp.osuosl.org/pub/xiph/releases/opus/opusfile-0.11.tar.gz"
	URL_HASH "SHA256=74ce9b6cf4da103133e7b5c95df810ceb7195471e1162ed57af415fabf5603bf"
	DEPENDENCIES Opus libogg
)
