shader_type spatial;

uniform sampler2D image;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 tex = texture(image, UV).rgb;
	if(tex.r < 0.1 && tex.g < 0.1 && tex.b < 0.1){
		discard;
	}else{
		ALBEDO = tex;
	}
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
