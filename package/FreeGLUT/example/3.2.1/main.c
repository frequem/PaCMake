#include <stdlib.h>
#include <GL/freeglut.h>

void displayFunc(void){
	glClearColor(0.0f, 0.4f, 0.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	glutSwapBuffers();
}
	
int main(int argc, char* argv[]){
	glutInit(&argc, argv);
	glutInitWindowSize(640, 480);
  
	if(glutCreateWindow("PaCMake example") < 1) {
		return EXIT_FAILURE;
	}

	glutDisplayFunc(displayFunc);
	glutMainLoop();
	
	return EXIT_SUCCESS;
}
