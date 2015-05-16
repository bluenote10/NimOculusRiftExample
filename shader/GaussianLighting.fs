#version 330

in vec4 diffuseColor;
in vec3 vertexNormal;
in vec3 cameraSpacePosition;

out vec4 outputColor;


uniform vec3 cameraSpaceLightPos = vec3(0, 0, 1);

uniform vec3 lightIntensity   = vec3(0.8,  0.8,  0.8);
uniform vec3 ambientIntensity = vec3(0.2,  0.2,  0.2);
const   vec3 specularColor    = vec3(0.25, 0.25, 0.25);

uniform float lightAttenuation = 0.05;
uniform float shininessFactor = 0.2;


float CalcAttenuation(in vec3 cameraSpacePosition, out vec3 lightDirection) {

	vec3 lightDifference =  cameraSpaceLightPos - cameraSpacePosition;
	float lightDistanceSqr = dot(lightDifference, lightDifference);
	lightDirection = lightDifference * inversesqrt(lightDistanceSqr);
	
	return (1 / ( 1.0 + lightAttenuation * sqrt(lightDistanceSqr)));
	//return (1 / ( 1.0 + lightAttenuation * lightDistanceSqr));
}


float rand(vec2 co){
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec3 noisy(in vec3 v) {
  float noise = rand(cameraSpacePosition.xy) * 3 - 1; // alternatively use gl_FragCoord.xy for a deterministic seed
  return vec3((v.r * 256 + noise) / 256, (v.g * 256 + noise) / 256, (v.b * 256 + noise) / 256);
}


void main() {
  // calc lightDir + attenuation
	vec3 lightDir = vec3(0.0);
	float atten = CalcAttenuation(cameraSpacePosition, lightDir);
	vec3 attenIntensity = atten * lightIntensity;
	
	// calc cosAngIncidence
	vec3 surfaceNormal = normalize(vertexNormal);
	float cosAngIncidence = dot(surfaceNormal, lightDir);
	cosAngIncidence = clamp(cosAngIncidence, 0, 1);
	
	vec3 viewDirection = normalize(-cameraSpacePosition);
	
	// calc gaussian term
	vec3 halfAngle = normalize(lightDir + viewDirection);
	float angleNormalHalf = acos(dot(halfAngle, surfaceNormal));
	float exponent = angleNormalHalf / shininessFactor;
	exponent = -(exponent * exponent);
	float gaussianTerm = exp(exponent);

	gaussianTerm = cosAngIncidence != 0.0 ? gaussianTerm : 0.0;

	vec3 outputColorWithoutAlpha = 
	  (diffuseColor.xyz * attenIntensity * cosAngIncidence) +
		(specularColor * attenIntensity * gaussianTerm) +
		(diffuseColor.xyz * ambientIntensity);

  // version without noise
  // outputColor = vec4(outputColorWithoutAlpha, diffuseColor.a);
  
  // added noise
  outputColor = vec4(noisy(outputColorWithoutAlpha.rgb), diffuseColor.a);

  // for debugging (best to condition on outputColor to avoid attribute/uniform removal)
  /*
  if (outputColor.x != 100) {
    outputColor = vec4(1, 0, 0, 1);
  }
  */
}




/*

in vec4 diffuseColor;
in vec3 vertexNormal;
in vec3 cameraSpacePosition;

out vec4 outputColor;

uniform vec3 modelSpaceLightPos = vec3(100, 1, +10);  // unused??

uniform vec4 lightIntensity = vec4(0.8, 0.8, 0.8, 1.0);
uniform vec4 ambientIntensity = vec4(0.2, 0.2, 0.2, 1.0);

uniform vec3 cameraSpaceLightPos = vec3(0, 0, 1);

uniform float lightAttenuation = 0.05;

const vec4 specularColor = vec4(0.25, 0.25, 0.25, 1.0);
uniform float shininessFactor = 0.2;


float CalcAttenuation(in vec3 cameraSpacePosition, out vec3 lightDirection)
{
	vec3 lightDifference =  cameraSpaceLightPos - cameraSpacePosition;
	float lightDistanceSqr = dot(lightDifference, lightDifference);
	lightDirection = lightDifference * inversesqrt(lightDistanceSqr);
	
	return (1 / ( 1.0 + lightAttenuation * sqrt(lightDistanceSqr)));
	//return (1 / ( 1.0 + lightAttenuation * lightDistanceSqr));
}

void main()
{
	vec3 lightDir = vec3(0.0);
	float atten = CalcAttenuation(cameraSpacePosition, lightDir);
	vec4 attenIntensity = atten * lightIntensity;
	
	vec3 surfaceNormal = normalize(vertexNormal);
	float cosAngIncidence = dot(surfaceNormal, lightDir);
	cosAngIncidence = clamp(cosAngIncidence, 0, 1);
	
	vec3 viewDirection = normalize(-cameraSpacePosition);
	
	vec3 halfAngle = normalize(lightDir + viewDirection);
	float angleNormalHalf = acos(dot(halfAngle, surfaceNormal));
	float exponent = angleNormalHalf / shininessFactor;
	exponent = -(exponent * exponent);
	float gaussianTerm = exp(exponent);

	gaussianTerm = cosAngIncidence != 0.0 ? gaussianTerm : 0.0;

  / *
	outputColor = (diffuseColor * attenIntensity * cosAngIncidence) +
		(specularColor * attenIntensity * gaussianTerm) +
		(diffuseColor * ambientIntensity);
  * /
  outputColor = vec4(((vec3(diffuseColor) * vec3(attenIntensity) * cosAngIncidence) +
    (vec3(specularColor) * vec3(attenIntensity) * gaussianTerm) +
    (vec3(diffuseColor) * vec3(ambientIntensity))), diffuseColor.a);

  //if (cosAngIncidence > -1) {
  //  outputColor = vec4(1, 0, 0, 1);
  //}
	
	// outputColor = diffuseColor;
	// outputColor = vec4(1, 0, 0, 1);

  // debug test: gl_FragColor = vec4(1, 0, 0, 1);
}

*/
