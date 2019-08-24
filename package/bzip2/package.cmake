pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(bzip2 1.0.8)

pacmake_register_package(
	bzip2
	VERSION 1.0.8
	URL "https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz"
	URL_HASH "SHA256=ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269"
)
