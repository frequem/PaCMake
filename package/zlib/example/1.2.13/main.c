#include <stdlib.h>
#include <string.h>
#include <zlib.h>

int main(int argc, char **argv) {
	char* in = "PaCMake test! PaCMake test! PaCMake test!";
	char* out = malloc(strlen(in) + 1);
	
	z_stream stream;
	stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.avail_in = strlen(in) + 1;
    stream.next_in = (Bytef*)in;
    stream.avail_out = stream.avail_in;
    stream.next_out = (Bytef*)out;
    
    deflateInit(&stream, Z_BEST_COMPRESSION);
    deflate(&stream, Z_FINISH);
    deflateEnd(&stream);
	
    free(out);
    return 0;
}
