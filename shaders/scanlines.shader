extern float time;
extern float setting1;
extern float setting2;
  vec4 effect( vec4 color, Image tex, vec2 tex_uv, vec2 pix_uv )
  {  
    // per row offset
    float f  = sin( tex_uv.y * setting1 * 3.14 );
    // scale to per pixel
    float o  = f * (0.35 / setting2);
    // scale for subtle effect
    //float s  = f * 0.07 + 0.97;
    // scan line fading
    float l  = sin( time * 32.0 )*0.03 + 0.97;
    // sample in 3 colour offset
    float r = Texel( tex, vec2( tex_uv.x+o, tex_uv.y+o ) ).x;
    float g = Texel( tex, vec2( tex_uv.x-o, tex_uv.y+o ) ).y;
    float b = Texel( tex, vec2( tex_uv.x  , tex_uv.y-o ) ).z;
    // combine as 
    return vec4( r*0.95, g, b*0.95, l );
  }