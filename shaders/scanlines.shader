extern float time;
extern float setting1;
extern float setting2;
  vec4 effect( vec4 color, Image tex, vec2 tex_uv, vec2 pix_uv )
  {  
    float f  = sin( tex_uv.y * setting1 * 3.14 );
    float o  = f * (0.35 / setting2);
    float l  = sin( time * 32.0 )*0.03 + 0.97;
    float r = Texel( tex, vec2( tex_uv.x+o, tex_uv.y+o ) ).x;
    float g = Texel( tex, vec2( tex_uv.x-o, tex_uv.y+o ) ).y;
    float b = Texel( tex, vec2( tex_uv.x  , tex_uv.y-o ) ).z;
    return vec4( r*0.95, g, b*0.95, l );
  }