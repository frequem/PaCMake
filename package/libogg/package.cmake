pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(libogg 1.3.3)

pacmake_register_package(
	libogg
	VERSION 1.3.3
	URL "https://github.com/xiph/ogg/archive/v1.3.3.tar.gz"
	URL_HASH "SHA256=e90a47bb9f9fd490644f82a097c920738de6bfcbd2179ec354e11a2cd3b49806"
)
