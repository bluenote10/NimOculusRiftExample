#version 110

void main(void) {
    
    // mix colors
    gl_FragColor = gl_Color;
    
    //gl_FragColor = mix(gl_Color, vec4(vec3(gl_SecondaryColor), 1.0), 0.5);
    
}

