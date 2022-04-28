shader_type spatial;
render_mode diffuse_burley, specular_schlick_ggx,world_vertex_coords;

uniform sampler2D tex_albedo: hint_albedo;
uniform float animspeed=1;

uniform float mindist = 0.9;
uniform float maxdist = 1.7;
uniform vec3 center = vec3(0,0,0);

varying float dist;

void vertex(){
	vec3 world_position = (WORLD_MATRIX * vec4(VERTEX, 1.0)).xyz;
	UV.y-=animspeed*TIME;
	
  float x = VERTEX.x-center.x;
  float z = VERTEX.z-center.z;
  float d = sqrt(x*x+z*z);
  float r = (d-mindist)/(maxdist-mindist);
  dist=1.0-clamp(r,0.0,1.0);

}

void fragment() {
	// sample all the textures
	ALBEDO = texture(tex_albedo, UV).rgb;
	ALPHA = dist*0.8;
}