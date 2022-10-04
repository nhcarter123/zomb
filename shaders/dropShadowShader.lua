return love.graphics.newShader[[
    extern float slope;
    extern float shadowLength;

    vec4 effect( vec4 col, Image texture, vec2 texturePos, vec2 screenPos )
    {
        float alpha = 0;
        float baseAlpha = 0.9 - abs(shadowLength) * 3;
        float ratio = texturePos.x / texturePos.y;

        vec2 scaledPos = texturePos * 2 - 0.5;

        float diff = abs(scaledPos.y - scaledPos.x);
        float factor = shadowLength * diff / 1.7 + shadowLength;

        if (diff < sign(shadowLength) * factor * 2) {
            scaledPos = scaledPos - sign(shadowLength) * vec2(-diff, diff / slope) / 2;
        } else {
            scaledPos = scaledPos - vec2(-factor, factor / slope);
        }

        alpha = baseAlpha * Texel(texture, scaledPos).a * (1 - diff / 2);

        return vec4(0, 0, 0, alpha);
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