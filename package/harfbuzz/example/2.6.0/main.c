#include <hb.h>

int main(int argc, char **argv) {
    hb_buffer_t *buf;
    buf = hb_buffer_create();
    hb_buffer_destroy(buf);
    return 0;
}
