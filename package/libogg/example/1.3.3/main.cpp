#include <iostream>
#include <ogg/ogg.h>

int main(int argc, char **argv){
	ogg_sync_state s;
	ogg_sync_init(&s);
	ogg_sync_clear(&s);
    return 0;
}
