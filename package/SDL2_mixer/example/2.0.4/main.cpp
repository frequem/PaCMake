#include <iostream>
#include <SDL.h>
#include <SDL_mixer.h>

int main(int argc, char **argv) {
	if(SDL_Init(SDL_INIT_AUDIO)==-1){
		printf("SDL_Init: %s\n", SDL_GetError());
		return 1;
	}
		
	int init = Mix_Init(MIX_INIT_FLAC|MIX_INIT_MOD|MIX_INIT_MP3|MIX_INIT_OGG);
	
	printf("MIX_INIT_FLAC...%s\n", (init&MIX_INIT_FLAC)?"success":"error");
	printf("MIX_INIT_MOD....%s\n", (init&MIX_INIT_MOD)?"success":"error");
	printf("MIX_INIT_MP3....%s\n", (init&MIX_INIT_MP3)?"success":"error");
	printf("MIX_INIT_OGG....%s\n", (init&MIX_INIT_OGG)?"success":"error");
	
	/*
	if(Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 1024)==-1){
		printf("Mix_OpenAudio error\n");
		return 1;
    }
	
	Mix_Music *mus = Mix_LoadMUS("test.xm");
	if(mus == nullptr){
		printf("Mix_LoadMUS error: %s\n", Mix_GetError());
		return 1;
	}	 
	if(Mix_PlayMusic(mus, -1)==-1){
		printf("Mix_PlayMusic error: %s\n", Mix_GetError());
		return 1;
	}
	
	SDL_Event e;
	bool running = true;
	while(running){
		while(SDL_PollEvent(&e)){
			if(e.type == SDL_QUIT){
				running = false;
			}
		}
		SDL_Delay(20);
	}
	
	Mix_FreeMusic(mus);
	*/
	Mix_Quit();
	SDL_Quit();
	return 0;
}
