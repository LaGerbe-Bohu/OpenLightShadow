#version 330 core
out vec4 FragColor;

in vec3 TexCoords;

uniform samplerCube skybox;

uniform Matrices {
	mat4 u_ViewMatrix;
	mat4 u_ProjectionMatrix;
};


void main()
{    
    vec4 texColor = texture(skybox, TexCoords);
	FragColor = texColor;

}