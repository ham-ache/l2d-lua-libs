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
uniform float time;
uniform float seed;
uniform vec2 bgOffset;
uniform float tmult;
vec2 resolution = vec2(960, 540);

float hash(float n){
    return fract(sin(n) * seed * 1000);
}
float noise(vec2 p){
    vec2 f = fract(p);
    f = f * f * (3 - 2 * f);
    
    float n = floor(p).x + floor(p).y * 57;
    float a = hash(n);
    float b = hash(n + 1);
    float c = hash(n + 57);
    float d = hash(n + 58);

    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}
float fbm(vec2 p){
    float val = 0;
    float amp = 0.26;
    float freq = 4;
    for(int x = 0; x < 5; x++){
        val += amp*noise(p*freq);
        amp /= 1.8;
        freq *= 3.5;
    }
    return val;
}
vec4 effect(vec4 color, Image tex, vec2 texpos, vec2 pos) {
    vec2 uv = pos / resolution.xy;
    vec2 cloudPos = vec2((uv.x + bgOffset.x) * 0.3 + time*tmult, (uv.y + bgOffset.y/200));
    float cloudNoise = fbm(cloudPos) + (fbm(cloudPos*2 + vec2(time*tmult,0)));
    float cloudDensity = smoothstep(1 - min(bgOffset.y/150, 1), 1, cloudNoise);

    return vec4(mix(vec3(0,0,0), vec3(1,1,1), cloudDensity), 1.0) * color;
}