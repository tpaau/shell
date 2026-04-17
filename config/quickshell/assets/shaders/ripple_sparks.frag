#version 450

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float widthPx;
    float heightPx;
    vec2 noiseOffset;
    float cornerRadiusPx;
    float rippleCenterX;
    float rippleCenterY;
    float rippleRadius;
    float rippleOpacity;
    float offsetX;
    float offsetY;
    float parentWidth;
    float parentHeight;
    vec4 rippleCol;
    vec4 secondaryCol;
} ubuf;

layout(binding = 1) uniform sampler2D source;

float sdRoundRect(vec2 p, vec2 b, float r) {
    vec2 q = abs(p) - (b - vec2(r));
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - r;
}

vec4 lerpColor(vec4 a, vec4 b, float t) {
    return vec4(mix(a.rgb, b.rgb, t), mix(a.a, b.a, t));
}

void main() {
    if (ubuf.rippleOpacity <= 0.0 || ubuf.rippleRadius <= 0.0) {
        fragColor = vec4(0.0);
        return;
    }

    vec2 px = qt_TexCoord0 * vec2(ubuf.widthPx, ubuf.heightPx) + vec2(ubuf.offsetX, ubuf.offsetY);

    float circleD = length(px - vec2(ubuf.rippleCenterX, ubuf.rippleCenterY)) - ubuf.rippleRadius;
    float aaCircle = max(fwidth(circleD), 0.001);
    float circleMask = 1.0 - smoothstep(-aaCircle, aaCircle, circleD);
    if (circleMask <= 0.0) {
        fragColor = vec4(0.0);
        return;
    }

    float rrMask = 1.0;
    if (ubuf.cornerRadiusPx > 0.0) {
        vec2 halfSize = vec2(ubuf.parentWidth, ubuf.parentHeight) * 0.5;
        float r = clamp(ubuf.cornerRadiusPx, 0.0, min(halfSize.x, halfSize.y));
        float rrD = sdRoundRect(px - halfSize, halfSize, r);
        float aaRR = max(fwidth(rrD), 0.001);
        rrMask = 1.0 - smoothstep(-aaRR, aaRR, rrD);
    }

    float mask = circleMask * rrMask;
    if (mask <= 0.0) {
        fragColor = vec4(0.0);
        return;
    }

    float noise_sample1 = texture(source, qt_TexCoord0).r;
    float noise_sample2 = texture(source, qt_TexCoord0 + ubuf.noiseOffset).r;
    float mul = noise_sample1 * noise_sample2;
    vec4 col = lerpColor(ubuf.rippleCol, ubuf.secondaryCol, mul);
    // float a = ubuf.rippleCol.a * ubuf.rippleOpacity * mask * ubuf.qt_Opacity;
    // fragColor = vec4(col.rgb, a);
    fragColor = col;
}
