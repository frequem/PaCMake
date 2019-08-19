pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(glm 0.9.9.5)

pacmake_register_package(
	glm
	VERSION 0.9.9.5
	URL "https://github.com/g-truc/glm/archive/0.9.9.5.tar.gz"
	URL_HASH "SHA256=5e33b6131cea6a904339734b015110d4342b7dc02d995164fdb86332d28a5aa4"
	CMAKE_ARGS "-DGLM_TEST_ENABLE=OFF"
)
