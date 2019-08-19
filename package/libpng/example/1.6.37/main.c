#include <png.h>

int main(int argc, char **argv) {
	png_structp png = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
	png_destroy_read_struct(&png, NULL, NULL);
    return 0;
}
