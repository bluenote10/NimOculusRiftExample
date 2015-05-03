#version 330

layout(location = 0) in vec3 position;
layout(location = 1) in vec2 textureCoord;

out vec2 vertexTextureCoord;

uniform mat4 modelToCameraMatrix;
uniform mat4 cameraToClipMatrix;


void main()
{
	gl_Position = cameraToClipMatrix * (modelToCameraMatrix * vec4(position, 1.0));

	vertexTextureCoord = textureCoord;
}
