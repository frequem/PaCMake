pacmake_register_package(
	3.12.0 FINAL
	SOURCES URL "https://github.com/nlohmann/json/releases/download/v3.12.0/json.tar.xz" URL_HASH "SHA256=42f6e95cad6ec532fd372391373363b62a14af6d771056dbfc86160e6dfff7aa"
	CMAKE_ARGS -DJSON_BuildTests=OFF
)
