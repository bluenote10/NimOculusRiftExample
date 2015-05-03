#version 330

in vec2 vertexTextureCoord;

uniform sampler2D sampler;
uniform vec4 color = vec4(1.0, 1.0, 1.0, 1.0);

out vec4 outputColor;

void main()
{
	vec4 textureColor = texture(sampler, vertexTextureCoord);
	
	// TODO: premultiplied alpha
	outputColor = textureColor.r * color;
}
