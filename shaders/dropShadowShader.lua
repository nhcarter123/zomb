return love.graphics.newShader[[
    extern vec4 size;
    extern vec2 shadow;

    vec4 effect( vec4 col, Image texture, vec2 texturePos, vec2 screenPos )
    {
        float alpha = 0;
        float length = shadow.x;
        // float baseAlpha = 0.9 - shadow.x * 3;
        float baseAlpha = 0.3 + 3 * shadow.x - 12 * pow(shadow.x + 0.24, 4);
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
        float factor = length * dist / 0.9 + length * size.z;

        float diff = mod((t - dir) + 3.14159265, 6.28318531) - 3.14159265;

        //if (diff < sign(length) * factor * 2) {
        //    scaledPos = scaledPos - sign(length) * vec2(-diff, diff) / vec2(size.x, size.y) / 2;
        //} else {
        //    scaledPos = scaledPos - vec2(-factor, factor) / vec2(size.x, size.y);
        //}

        //scaledPos = scaledPos / (1 + dist / 4);

        float mag = distance(vec2(0), vec2(size.x, size.y));

        if (abs(diff) > 1.5708) {
            if (dist > factor) {
                scaledPos = scaledPos + vec2(xdiff, ydiff) * factor;
            } else {
                scaledPos = scaledPos + vec2(xdiff, ydiff) * dist;
            }

            float slopeFactor = 1 + (size.w - 1) / 5;
            float fade = max(1 - 0.3 * (dist * mag * slopeFactor) / size.z, 0);
            alpha = baseAlpha * Texel(texture, scaledPos).a * fade;
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