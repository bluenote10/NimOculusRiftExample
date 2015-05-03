#version 120

uniform sampler2D sampler0;
uniform vec2 u_texRange;
uniform vec2 u_lensCenterOffset;
uniform vec4 u_distortion;
uniform float u_aspect;
uniform float u_fillScale;

float distortionScale(vec2 offset) {
    // Note that this performs piecewise multiplication,
    // NOT a dot or cross product
    vec2 offsetSquared = offset * offset;
    float radiusSquared = offsetSquared.x + offsetSquared.y;
    float distortionScale = //
            u_distortion[0] + //
            u_distortion[1] * radiusSquared + //
            u_distortion[2] * radiusSquared * radiusSquared + //
            u_distortion[3] * radiusSquared * radiusSquared * radiusSquared;
    return distortionScale;
}

vec2 textureCoordsToDistortionOffsetCoords(vec2 texCoord) {
    // Convert the texture coordinates from "0 to 1" to "-1 to 1"
    vec2 result = texCoord * 2.0 - 1.0;

    // Convert from using the center of the screen as the origin to
    // using the lens center as the origin
    result -= u_lensCenterOffset;

    // Correct for the aspect ratio
    result.y /= u_aspect;

    return result;
}

vec2 distortionOffsetCoordsToTextureCoords(vec2 offset) {
    // Scale the distorted result so that we fill the desired amount of pixel real-estate
    vec2 result = offset / u_fillScale;

    // Correct for the aspect ratio
    result.y *= u_aspect;

    // Convert from using the lens center as the origin to
    // using the screen center as the origin
    result += u_lensCenterOffset;

    // Convert the texture coordinates from "-1 to 1" to "0 to 1"
    result /= 2.0;  result += 0.5;

    return result;
}

void main(){
    // Grab the texture coordinate, which will be in the range 0-1 in both X and Y
    vec2 offset = textureCoordsToDistortionOffsetCoords(gl_TexCoord[0].st);

    // Determine the amount of distortion based on the distance from the lens center
    float scale = distortionScale(offset);

    // Scale the offset coordinate by the distortion factor introduced by the Rift lens
    vec2 distortedOffset = offset * scale;

    // Now convert the data back into actual texture coordinates
    vec2 actualTextureCoords = distortionOffsetCoordsToTextureCoords(distortedOffset);

    // The actual texture data doesn't necessarily occupy the entire width and height
    // of the texture, so we apply a scale that has been provided by the application
    // to only access the parts of the texture that are valid
    actualTextureCoords *= u_texRange;

    // Ensure that the distorted coordinates are not outside the range of the texture
    vec2 clamped = clamp(actualTextureCoords, vec2(0, 0), u_texRange);

    if (!all(equal(clamped, actualTextureCoords))) {
        gl_FragColor = vec4(0, 0, 1, 1);
    } else {
        gl_FragColor = texture2D(sampler0, actualTextureCoords );
    }
//    gl_FragColor = vec4(actualTextureCoords, 1, 1);
}
