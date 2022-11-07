return love.graphics.newShader[[
    extern vec2 shadow;
    extern vec2 ratio;

    const int   SAMPLES = 16;
    const float LENGTH = 0.1 / SAMPLES;
    const float STRENGTH = 1.4;

    vec4 effect( vec4 col, Image texture, vec2 texturePos, vec2 screenPos )
    {

        float mag = length(shadow);
        float baseAlpha = 0.8 - mag - 2 * pow(mag, 2);

        float alpha = 0;
        for (int i = 1; i <= SAMPLES; ++i) {
            vec2 dist = LENGTH / ratio * shadow * float(i);
            // alpha = max(alpha, 0.8 * STRENGTH * Texel(texture, texturePos + dist).a); // none
            // alpha = max(alpha, STRENGTH * Texel(texture, texturePos + dist).a * (SAMPLES - float(i)) / SAMPLES); // x
            // alpha = max(alpha, STRENGTH * Texel(texture, texturePos + dist).a * (-pow(float(i) / SAMPLES, 2) + 1)); // x^2
            alpha = max(alpha, STRENGTH * Texel(texture, texturePos + dist).a * (2 * SAMPLES / (float(i) + SAMPLES) - 1)); // 1/x
        }

        return vec4(0, 0, 0, baseAlpha * alpha);
    }
]]