pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(Opus 1.3.1)

pacmake_register_package(
	Opus
	VERSION 1.3.1
	URL "https://github.com/xiph/opus/archive/v1.3.1.tar.gz"
	URL_HASH "SHA256=4834a8944c33a7ecab5cad9454eeabe4680ca1842cb8f5a2437572dbf636de8f"
)
