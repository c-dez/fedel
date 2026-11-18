shader_type spatial;

// version 2!

uniform vec3 albedo:source_color;
uniform float metallic:hint_range(0.0, 1.0) = 0;
uniform float roughness:hint_range(0.0, 1.0) = 0.02;

uniform sampler2D texture_normal;
uniform sampler2D texture_normal2;
uniform vec2 wave_direction1 = vec2(2.0, 0.0);
uniform vec2 wave_direction2 = vec2(0.0, 1.0);

uniform float time_scale : hint_range(0.0, 0.2, 0.005) =0.025;


// mover vertex.y siguiendo formula de olas dos olas
uniform float amplitude1 = 0.3;
uniform float amplitude2 = 0.15;

uniform float wave_count1 = 2.0;
uniform float wave_count2 = 3.0;

uniform float speed1 = 1.0;
uniform float speed2 = 1.5;
// usado para aplicar al albedo
uniform float fresnel_mult :hint_range(0.0, 2.0, 0.05) = 0.5;
float fresnel(float amount,vec3 normal,vec3 view){
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)),amount);
}

void vertex() {
	// mover vertex.y siguiendo formula de olas

	float phase1 = UV.x * TAU * wave_count1 - TIME* speed1;
	float phase2 = UV.y * TAU * wave_count2 - TIME* speed2;

	float wave1 = sin(phase1) * amplitude1;
	float wave2 = sin(phase2) * amplitude2;
	
	VERTEX.y += wave1 + wave2;
///////////
}


void fragment() {
	vec2 time1 = (TIME * wave_direction1) * time_scale;
	vec2 time2 = (TIME * wave_direction2) * time_scale;
	
	vec3 normal_blend = mix(texture(texture_normal,UV + time1).rgb, texture(texture_normal2, UV + time2).rgb, 0.5);
	
	NORMAL_MAP = normal_blend;
	
	float basic_fresnel = fresnel(3.0,NORMAL, VIEW);

	ALBEDO = albedo + (fresnel_mult * basic_fresnel);
	// ALBEDO = albedo;
	METALLIC = metallic;
	ROUGHNESS =roughness * (1.0 - basic_fresnel);

}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
