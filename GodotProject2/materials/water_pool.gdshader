shader_type spatial;
render_mode diffuse_burley, specular_schlick_ggx;

uniform sampler2D tex_albedo: hint_albedo;
uniform float animspeed=1;

void vertex(){
	UV.x += sin(TIME/15.0+UV.x*1034.5);
	UV.y += sin(TIME/10.0+UV.y*234.1);
}

void fragment() {
	// sample all the textures
	ALBEDO = texture(tex_albedo, UV).rgb;
	ALPHA = 0.8;
}