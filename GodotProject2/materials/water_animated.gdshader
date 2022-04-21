shader_type spatial;
render_mode diffuse_burley, specular_schlick_ggx;

uniform sampler2D tex_albedo: hint_albedo;
uniform float animspeed=1;

void vertex(){
	vec3 world_position = (WORLD_MATRIX * vec4(VERTEX, 1.0)).xyz;
	UV.y-=animspeed*TIME;
}

void fragment() {
	// sample all the textures
	ALBEDO = texture(tex_albedo, UV).rgb;
	ALPHA = 0.8;
}