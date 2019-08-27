#include <iostream>
#include <opus/opus.h>

int main(int argc, char **argv){
	int err;
	OpusEncoder *enc = opus_encoder_create(48000, 2, OPUS_APPLICATION_AUDIO, &err);
	if(err<0){
		fprintf(stderr, "failed to create an encoder: %s\n", opus_strerror(err));
		return 1;
	}
	
	printf("ok\n");
	
	opus_encoder_destroy(enc);
    return 0;
}
