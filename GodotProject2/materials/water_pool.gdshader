shader_type spatial;
render_mode diffuse_burley, specular_schlick_ggx,world_vertex_coords;

uniform float mindist = 0.9;
uniform float maxdist = 1.7;
uniform vec3 center = vec3(0,0,0);

uniform sampler2D tex_albedo: hint_albedo;
uniform float animspeed=1;

varying float dist;

void vertex(){
	UV.x += sin(TIME/15.0+UV.x*1034.5);
	UV.y += sin(TIME/10.0+UV.y*234.1);

  float x = VERTEX.x-center.x;
  float z = VERTEX.z-center.z;
  float d = sqrt(x*x+z*z);
  float r = (d-mindist)/(maxdist-mindist);
  dist=1.0-clamp(r,0.0,1.0);

}



void fragment() {
	// sample all the textures
	ALBEDO = texture(tex_albedo, UV).rgb;
  ALPHA=dist*0.8;
}