return love.graphics.newShader[[
    extern vec2 shadow;
    extern vec3 size;
    extern vec2 ratio;

    const int   SAMPLES = 16;
    const float POWER   = 2.0 / float(SAMPLES);
    const float DECAY   = 1;

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