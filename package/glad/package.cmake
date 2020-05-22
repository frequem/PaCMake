pacmake_include(register_package)
pacmake_include(default_version)

pacmake_set_default_version(glad 0.1.33)

pacmake_register_package(
	glad
	VERSION 0.1.33
	URL "https://github.com/Dav1dde/glad/archive/v0.1.33.tar.gz"
	URL_HASH "SHA256=4bc850062e9bcfc182bd4095d45b987517507d8ec0edcc424ed58f67b4ea9e37"
	CMAKE_ARGS "-DGLAD_INSTALL=ON"
)
