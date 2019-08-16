#include <unistd.h>
#include <stringhelper/string.h>

int main(int argc, char **argv) {
	string_t s = STRING_INITIALIZER;
	string_copy(&s, string_cstr("ok!\n"));
	string_write(STDOUT_FILENO, &s);
    return 0;
}
