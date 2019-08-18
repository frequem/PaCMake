#include <ft2build.h>
#include <freetype/freetype.h>

int main(int argc, char **argv) {
	FT_Library ftlib;
	FT_Init_FreeType(&ftlib);
	FT_Done_FreeType(ftlib);
    return 0;
}
