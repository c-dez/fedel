shader_type spatial;

uniform float stepness:hint_range(0.0, 1.0, 0.05) = 0.5;
uniform vec3 color: source_color;

// normals
uniform float sampling_distance = 0.01;

uniform sampler2D noise;
uniform float noise_intensity:hint_range(0.0, 1.0, 0.1) = 0.2;
uniform float amplitude1 = 0.5;
uniform float amplitude2 = 0.2;
uniform float wave_count1 = 0.5;
uniform float wave_count2 = 0.8;
uniform float time_scale :hint_range(0.0, 0.1, 0.01) = 0.05;

vec3 gerstner(vec2 pos,vec2 direction, float amplitude, float frecuency){
	direction = normalize(direction);
	float noise_value = texture(noise, pos/10.0 + 0.5 + TIME * time_scale).r;
	float phase = (TIME + pos.x * direction.x + pos.y * direction.y) * frecuency;
	vec3 displacement;
	displacement.y = sin(phase) * amplitude + noise_value * noise_intensity;
	displacement.xz = direction * cos(phase) * stepness;

	return displacement;
}

vec3 wave(vec2 pos){
	vec3 displacement = gerstner(pos,vec2(1,0), amplitude1, wave_count1);
	//wave2
	displacement += gerstner(pos,vec2(0,1), amplitude2, wave_count2);
	//wave 3
	displacement += gerstner(pos,vec2(0,1), 0.1, 0.3);

	return displacement;
}


void vertex(){
	vec3 pos = VERTEX.xyz;
	
	VERTEX += wave(pos.xz);
	
	//normals
	vec3 fwd_pos = pos + vec3(0.0, 0.0, -1.0) * sampling_distance;
	vec3 left_pos = pos + vec3(-1.0, 0.0, 0.0) * sampling_distance;
	
	vec3 wave_fwd = fwd_pos + wave(fwd_pos.xz);
	vec3 wave_left = left_pos + wave(left_pos.xz);
	vec3 fwd_vec = wave_fwd - VERTEX;
	vec3 left_vec = wave_left - VERTEX;
	
	NORMAL = normalize(cross(fwd_vec, left_vec));
}



void fragment(){
	ALBEDO = color;
	ROUGHNESS = 0.01;
	
	RIM = 3.0;
}