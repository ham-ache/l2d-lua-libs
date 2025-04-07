/*
        MIT License

        Copyright (c) 2025 hamache

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
*/
uniform float split;
uniform vec3 palette[2]; // your 1-bit palette

vec4 effect(vec4 color, Image tex, vec2 texpos, vec2 pos) {
    vec4 texcolor = Texel(tex, texpos);
    pos = pos/split;
    if (texcolor.a > 0) {
        texcolor.rgb /= texcolor.a;
    }

    const float matrix[16] = float[16]( // bayer 4x4
        0.0, 8.0, 2.0, 10.0,
        12.0, 4.0, 14.0, 6.0,
        3.0, 11.0, 1.0, 9.0,
        15.0, 7.0, 13.0, 5.0
    );
    
    int x = int(mod(pos.x, 4.0)); 
    int y = int(mod(pos.y, 4.0));
    float dither = matrix[y * 4 + x] / 16;
    
    vec3 dcolor = texcolor.rgb + (dither - length(palette[0] - palette[1])/3.5) / 2;

    float alpha = texcolor.a;
    alpha = (alpha > dither) ? 1.0 : 0.0;
    
    return vec4((length(dcolor - palette[0]) < length(dcolor - palette[1])) ? palette[0] : palette[1], alpha);
}