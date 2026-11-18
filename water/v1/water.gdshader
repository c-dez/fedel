shader_type spatial;

// uniform float amplitude = 0.3;
// uniform float wave_count = 2.0;
// uniform float speed = 1.0;

uniform float amplitude1 = 0.3;
uniform float amplitude2 = 0.15;

uniform float wave_count1 = 2.0;
uniform float wave_count2 = 3.0;

uniform float speed1 = 1.0;
uniform float speed2 = 1.5;

void vertex(){
	// una onda
	//float phase = UV.x * TAU * wave_count - TIME * speed;
	//VERTEX.y += sin(phase) * amplitude;
	////////
	//dos ondas
	float phase1 = UV.x * TAU * wave_count1 - TIME * speed1;
	float phase2 = UV.y * TAU * wave_count2 - TIME * speed2;
	
	float wave1 = sin(phase1) * amplitude1;
	float wave2 = sin(phase2) * amplitude2;
	
	
	// derivadas
	float slope1 = amplitude1 * TAU * wave_count1 * cos(phase1);
	
	float slope2 = amplitude2 * TAU * wave_count2 * cos(phase2);
	
	// calculamos normal
	vec3 new_normal = normalize(vec3(-slope1, 1.0,- slope2));
	
	//NORMAL = new_normal;
	VERTEX.y += wave1 + wave2;
	
}

void fragment(){
	ALBEDO = vec3(0.0,0.35,0.55);
	ROUGHNESS = 0.2;
}
