uniform sampler2D sampler;
varying vec2 oTexCoord;

void main()
{
   gl_FragColor = texture(sampler, oTexCoord);
//   gl_FragColor = texture2D(sampler, oTexCoord);
//   gl_FragColor = mix( texture2D(sampler, oTexCoord), texture2D(sampler, oTexCoord + 0.001), 0.5);
//   gl_FragColor = vec4(oTexCoord, 0, 1);
}
