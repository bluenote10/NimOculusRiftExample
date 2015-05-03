#version 110

void main(void) {
    
    // normal MVP transform
    vec4 clipCoord = gl_ModelViewProjectionMatrix * gl_Vertex;
    gl_Position = clipCoord;
    
    // copy primary color
    gl_FrontColor = gl_Color;
    
    // calculate normal
    vec4 ndc = vec4(clipCoord.xyz / clipCoord.w, 1.0);
    
    // map
    //gl_SecondaryColor = (ndc * 0.5) + 0.5;
    //gl_FrontColor = (ndc * 0.5) + 0.5;
    
}

