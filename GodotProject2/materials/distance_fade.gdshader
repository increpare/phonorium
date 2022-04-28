shader_type spatial;
render_mode depth_draw_always,cull_back;
uniform sampler2D texturemap;

uniform float mindist = 0.9;
uniform float maxdist = 1.7;
uniform vec3 center = vec3(0,0,0);

varying vec2 tex_position;
varying float dist;

void vertex() {
  float x = VERTEX.x-center.x;
  float z = VERTEX.z-center.z;
  float d = sqrt(x*x+z*z);
  float r = (d-mindist)/(maxdist-mindist);
  dist=1.0-clamp(r,0.0,1.0);

}

void fragment() {
  ALBEDO.xyz = texture(texturemap, UV.xy).xyz;
  ALPHA=dist;
}