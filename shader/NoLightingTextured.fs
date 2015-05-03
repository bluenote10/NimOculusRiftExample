#version 330

in vec2 vertexTextureCoord;

uniform sampler2D sampler;
uniform float alpha = 1.0;

out vec4 outputColor;

void main()
{
	//outputColor = texture(sampler, vertexTextureCoord);
	
	vec4 textureColor = texture(sampler, vertexTextureCoord);
	
	// version without premultiplied alpha
	// outputColor = vec4(textureColor.rgb, textureColor.a * alpha);
	
	// premultiplied alpha
	// assuming textureColor.a is already multiplied and we only have to multiply by the global alpha
	outputColor = vec4(textureColor.rgb * alpha, textureColor.a * alpha);
}
