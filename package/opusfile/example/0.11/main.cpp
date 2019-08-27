#include <iostream>
#include <opusfile.h>

int main(int argc, char **argv){
	OpusTags tags;
	opus_tags_init(&tags);
	opus_tags_clear(&tags);
    return 0;
}
