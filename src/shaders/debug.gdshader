shader_type spatial;
//render_mode wireframe;
global uniform sampler2D heightmap;
global uniform sampler2D normalmap;

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}

varying vec3 vert;
void vertex() {
	
	//VERTEX += noise(vec2(VERTEX.x, VERTEX.y)) * NORMAL;
	//VERTEX.y += 2.0*cos(noise(VERTEX.xz));
	float height_range = 20.0;
	float height = texture(heightmap, UV).g * height_range;
	
	VERTEX.y = -5.0 + height;

	vec3 norm = texture(normalmap, UV).rgb;
	NORMAL = normalize(norm);
	vert = VERTEX;
	//VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX,0.0)).xyz;
}

void fragment() {
	ALBEDO = vec3(0.5,1,0.5);
	
	//BACKLIGHT = vec3(1,0,0);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
