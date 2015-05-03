#version 330

layout(location = 0) in vec3 position;
layout(location = 1) in vec4 color;

out vec4 vertexColor;

uniform mat4 modelToCameraMatrix;
uniform mat4 cameraToClipMatrix;


void main()
{
	gl_Position = cameraToClipMatrix * (modelToCameraMatrix * vec4(position, 1.0));

	vertexColor = color;
}
