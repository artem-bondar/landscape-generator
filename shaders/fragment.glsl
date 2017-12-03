#version 330 core
in vec3 vFragPosition;
in vec2 vTexCoords;
in vec3 vNormal;

out vec4 color;

uniform bool normalmap;
uniform bool shadowmap;
uniform sampler2D grass; 
uniform sampler2D water;
uniform sampler2D stone;
uniform sampler2D snow;
uniform sampler2D sand;

void main()
{
  vec3 lightDir = vec3(1.0f, 1.0f, 0.0f); 

  vec3 col = vec3(0.4f, 0.4f, 0.4f);

  float kd = max(dot(vNormal, lightDir), 0.0);

  float coef = 0.25f;

  if (shadowmap)
  {
	float near = 0.1; 
	float far  = 100.0;
	float depth = (2.0 * near * far) / (far + near - (gl_FragCoord.z * 2.0 - 1.0) * (far - near)) / far;
	color = vec4(vec3(depth), 1.0f);
  }
  else if (!normalmap)
	 //color = vec4(kd * col, 1.0f);
	 {
	 if (vFragPosition.y > 7.0f)
	  color = mix(texture(snow, vTexCoords), vec4(kd * col, 1.0), coef);
	 else if (vFragPosition.y > 5.0f)
	 {
		 for (float i = 0.0f; i <= 1.0f; i += 0.05f)
		if (vFragPosition.y <= 5.1f + (i / 0.05f) * 0.1f)
		 {
			 color = mix(texture(stone, vTexCoords), texture(snow, vTexCoords), i);
			 color = mix(color, vec4(kd * col, 1.0), coef);
			 break;
		 }
	 }
	 else if (vFragPosition.y > 4.0f)
	  color = mix(texture(stone, vTexCoords), vec4(kd * col, 1.0), coef);
	 else if (vFragPosition.y > 2.0f)
	  {
		 for (float i = 0.0f; i <= 1.0f; i += 0.05f)
		if (vFragPosition.y <= 2.1f + (i / 0.05f) * 0.1f)
		 {
			 color = mix(texture(grass, vTexCoords), texture(stone, vTexCoords), i);
			 color = mix(color, vec4(kd * col, 1.0), coef);
			 break;
		 }
	 }
	  else if (vFragPosition.y > 1.0f)
		color = mix(texture(grass, vTexCoords), vec4(kd * col, 1.0), coef);
	  else if (vFragPosition.y > 0.6f)
	{
	for (float i = 0.0f; i <= 1.0f; i += 0.05f)
		if (vFragPosition.y <= 0.62f + (i / 0.05f) * 0.02f)
		 {
			 color = mix(texture(sand, vTexCoords), texture(grass, vTexCoords), i);
			 color = mix(color, vec4(kd * col, 1.0), coef);
			 break;
		 }
	 }
	  else if (vFragPosition.y > 0.5f)
		color = mix(texture(sand, vTexCoords), vec4(kd * col, 1.0), coef);
	  else
	    color = mix(texture(water, vTexCoords), vec4(kd * col, 1.0), coef);
	  }
  else
	 color = vec4(vNormal, 1.0f);
}
