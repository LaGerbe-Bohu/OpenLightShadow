#version 450

// role du Vertex Shader:
// produire (au minimum) une position

in vec3 a_Position;
in vec3 a_Normal;
in vec2 a_TexCoords;

out vec3 v_FragPosition; // pour les calculs d'illumination
out vec2 v_TexCoords;
out vec3 v_Normal;

uniform mat4 u_WorldMatrix;
uniform vec3 u_lightDirection;

// un 'uniform block' pour nos matrices communes
uniform Matrices {
	mat4 u_ViewMatrix;
	mat4 u_ProjectionMatrix;
};

uniform LightMatrices {
	mat4 u_LightViewMatrix;
	mat4 u_LightProjectionMatrix;
};

out vec4 v_ShadowCoords;
out vec4 vertPosition;

uniform samplerCube skybox;

void main(void)
{
	v_TexCoords = a_TexCoords;

	// il ne faut pas oublier d'appliquer les transformations a la normale
	// ... sauf qu'on ne doit pas appliquer la translation (d'ou le mat3)
	// ... de plus ... si la matrice a du scale (ou pire non-uniform)
	// alors la normale peut etre perturbee : on corrige en appliquant 
	// la transposee de l'inverse de la Transform de l'objet
	v_Normal = mat3(transpose(inverse(u_WorldMatrix))) * a_Normal;
	
	vec4 position_world = u_WorldMatrix * vec4(a_Position, 1.0);

	v_FragPosition = position_world.xyz;

	// pour un projecteur ou shadow mapping, on ajoute
	vec4 light_ndc_position = u_LightProjectionMatrix * u_LightViewMatrix * position_world;

	// conversion des coordonnees de [-1;+1] vers [0;1] 
	// afin de les utiliser comme des coordonnees de texture
	mat4 biasMatrix = mat4(
				  0.5, 0.0, 0.0, 0.0
				, 0.0, 0.5, 0.0, 0.0
				, 0.0, 0.0, 0.5, 0.0
				, 0.5, 0.5, 0.5, 1.0 // 4eme colonne (+0.5)
	);

	

	//v_ShadowCoords = biasMatrix * light_ndc_position;
	v_ShadowCoords = biasMatrix*light_ndc_position;
	vertPosition = u_ProjectionMatrix * u_ViewMatrix * position_world;
	gl_Position = u_ProjectionMatrix * u_ViewMatrix * position_world;
}
