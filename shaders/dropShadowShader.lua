return love.graphics.newShader[[
    extern vec4 size;
    extern vec2 shadow;

    vec4 effect( vec4 col, Image texture, vec2 texturePos, vec2 screenPos )
    {
        float alpha = 0;
        float length = shadow.x;
        // float baseAlpha = 0.9 - shadow.x * 3;
        float baseAlpha = 0.78 - shadow.x - 2 * pow(shadow.x, 2);
        //float slope = size.y / size.x;

        //vec2 scaledPos = (texturePos * 2 - 0.5);
        vec2 scaledPos = (texturePos * vec2(size.x, size.y) - (vec2(size.x, size.y) * 0.5 - 0.5));
        //vec2 scaledPos = 2 * (texturePos * vec2(size.x, size.y) - vec2(size.x, size.y) / 2) + 0.5;

        //float diff = abs(scaledPos.y - scaledPos.x);

        float angle = shadow.y - ((size.w - 1) * sin(2 * shadow.y) / 3);
        float t = angle;
        float tp = angle + 1.5708;
        vec2 graphPos = scaledPos - vec2(0.5);
        float x = (-(graphPos.x) * tan(t) + (graphPos.y)) / (tan(tp) - tan(t));
        float y = tan(tp) * x;

        float dir = atan(graphPos.y - y, graphPos.x - x);
        float dist = distance(graphPos, vec2(x, y));
        float xdiff = cos(angle);
        float ydiff = sin(angle);
        //float factor = length * dist / 1.7 + length;
        float factor = length * dist + length * size.z * 0.7;
        //float factor = 2 * length * size.x;

        float diff = mod((t - dir) + 3.14159265, 6.28318531) - 3.14159265;
        float mag = max(size.x, size.y);

        float edgeAlpha = 1;
        float imageAlpha = 1;
        if (abs(diff) > 1.5708) {
            vec2 shadowPos = scaledPos + vec2(xdiff, ydiff) * dist;
            edgeAlpha = Texel(texture, shadowPos).a;

            if (dist > factor) {
                shadowPos = scaledPos + vec2(xdiff, ydiff) * factor;
                imageAlpha = Texel(texture, shadowPos).a;
            }

            float slopeFactor = 1 + (size.w - 1) / 5;
            float fade = max(1 - 0.4 * (dist * mag * slopeFactor) / size.z, 0);

            alpha = baseAlpha * min(edgeAlpha, imageAlpha) * fade;
        }

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