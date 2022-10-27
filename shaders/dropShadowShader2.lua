return love.graphics.newShader[[
    extern vec2 shadow;
    extern vec3 size;
    extern vec2 ratio;

    const int   SAMPLES = 16;
    const float POWER   = 2.0 / float(SAMPLES);
    const float DECAY   = 1;

    float rand(vec2 seed) { return fract(sin(dot(seed.xy ,vec2(12.9898, 78.233)))*43758.5453); }

    vec4 effect( vec4 col, Image texture, vec2 texturePos, vec2 screenPos )
    {

        float mag = distance(vec2(0), shadow);
        float baseAlpha = 0.8 - mag - 2 * pow(mag, 2);
        vec2 scaledPos = (texturePos * vec2(size.x, size.y) - (vec2(size.x, size.y) * 0.5 - 0.5));

        float alpha = 0;
        for (int i = 0; i < SAMPLES; ++i) {
            vec2 dist = 2 / ratio * shadow * size.z * float(i) * DECAY / float(SAMPLES);
            alpha = max(alpha, Texel(texture, scaledPos + dist).a / pow(1 + distance(vec2(0) * 6, dist), 2) );
        }

        return vec4(0, 0, 0, baseAlpha * alpha);
    }
]]

--return love.graphics.newShader[[
--    extern float slope;
--    extern float shadowLength;
--
--    vec4 effect( vec4 col, Image texture, vec2 texturePos, vec2 screenPos )
--    {
--        float alpha = 0;
--        float baseAlpha = 0.9 - abs(shadowLength) * 2.2;
--        float ratio = texturePos.x / texturePos.y;
--
--        vec2 scaledPos = texturePos * 2 - 0.5;
--
--        float diff = abs(scaledPos.y - scaledPos.x);
--        float factor = shadowLength * diff / 2 + shadowLength;
--
--        if (diff < sign(shadowLength) * factor * 2) {
--            scaledPos = scaledPos - sign(shadowLength) * vec2(-diff, diff / slope) / 2;
--        } else {
--            scaledPos = scaledPos - vec2(-factor, factor / slope);
--        }
--
--        alpha = baseAlpha * Texel(texture, scaledPos).a * (1 - diff / 2);
--
--        return vec4(0, 0, 0, alpha);
--    }
--]]