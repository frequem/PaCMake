#include <stdio.h>
#include <stdlib.h>
#include <GL/glew.h>
#include <GLFW/glfw3.h>
	
int main(int argc, char* argv[]){
	if(glfwInit() != GLFW_TRUE){
		fprintf(stderr, "glfwInit failed\n");
		return EXIT_FAILURE;
	}
	
	GLFWwindow* window = glfwCreateWindow(640, 480, "PaCMake glfw example", NULL, NULL);
	if(window==NULL){
		fprintf(stderr, "glfwCreateWindow failed\n");
		return EXIT_FAILURE;
	}
	
	glfwMakeContextCurrent(window);
	
	while(!glfwWindowShouldClose(window)){
		glfwPollEvents();
		
		glClearColor(0.0f, 0.4f, 0.0f, 1.0f);
		glClear(GL_COLOR_BUFFER_BIT);
		
		glfwSwapBuffers(window);
	}
	
	
	glfwDestroyWindow(window);
	glfwTerminate();
	return EXIT_SUCCESS;
}
