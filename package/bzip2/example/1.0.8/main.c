#include <stdio.h>
#include <bzlib.h>

int main(int argc, char **argv) {
	printf("bzip2 version: %s.\n", BZ2_bzlibVersion());
    return 0;
}
