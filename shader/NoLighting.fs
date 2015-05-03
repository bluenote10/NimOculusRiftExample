#version 330

in vec4 vertexColor;

out vec4 outputColor;

void main()
{
	outputColor = vertexColor;
	
	/*
	if (vertexColor.x > 0)
	  outputColor = vec4(0, 1, 0, 1);
	else
	  outputColor = vec4(1, 0, 0, 1);
	*/
}
