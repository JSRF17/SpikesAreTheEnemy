
//Public domain:

//Copyright (C) 2017 by Matthias Richter <vrld@vrld.org>

//Permission to use, copy, modify, and/or distribute this software for any
//purpose with or without fee is hereby granted.

//THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
//REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
//FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
//INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
//LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
//OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
//PERFORMANCE OF THIS SOFTWARE.

 
extern vec2 size;
extern number feedback;
vec4 effect(vec4 color, Image tex, vec2 tc, vec2 _)
  {
    vec4 c = Texel(tex, tc);

    // average pixel color over 5 samples
    vec2 scale = love_ScreenSize.xy / size;
    tc = floor(tc * scale + vec2(.5));
    vec4 meanc = Texel(tex, tc/scale);
    meanc += Texel(tex, (tc+vec2( 1.0,  .0))/scale);
    meanc += Texel(tex, (tc+vec2(-1.0,  .0))/scale);
    meanc += Texel(tex, (tc+vec2(  .0, 1.0))/scale);
    meanc += Texel(tex, (tc+vec2(  .0,-1.0))/scale);

    return color * mix(.2*meanc, c, feedback);
  }