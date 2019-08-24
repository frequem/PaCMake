#include <iostream>
#include <SDL_mixer.h>

int main(int argc, char **argv) {
	Mix_Init(MIX_INIT_FLAC|MIX_INIT_MOD|MIX_INIT_MP3|MIX_INIT_OGG);
	Mix_Quit();
	return 0;
}
