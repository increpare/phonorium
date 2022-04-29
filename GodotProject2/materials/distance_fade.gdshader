shader_type spatial;
render_mode depth_draw_always,cull_back, world_vertex_coords;
uniform sampler2D texturemap;
uniform vec4 tint : hint_color = vec4(1,1,1,1);
uniform float mindist = 0.9;
uniform float maxdist = 1.7;
uniform vec3 center = vec3(0,0,0);
uniform float metallic = 0;

varying vec2 tex_position;
varying float dist;

void vertex() {
  float x = VERTEX.x-center.x;
  float y = VERTEX.y-center.y;
  float z = VERTEX.z-center.z;
  float d = sqrt(x*x+z*z+2.0*y*y);
  float r = (d-mindist)/(maxdist-mindist);
  dist=1.0-clamp(r,0.0,1.0);

}

void fragment() {
  ALBEDO.xyz = texture(texturemap, UV.xy).xyz*tint.xyz;
  ALPHA=dist;
  METALLIC = metallic;
}