pacmake_register_package(
	8.21.0 FINAL
	SOURCES URL "https://github.com/curl/curl/releases/download/curl-8_21_0/curl-8.21.0.tar.gz" URL_HASH "SHA256=d9b327997999045a24cda50f3983e69e51c516bd8be6ef9842fc7f99135e33bb"
	CMAKE_ARGS -DCURL_CA_FALLBACK=ON
)
