function createFOWShader()
    return love.graphics.newShader[[
        #define MAX_LIGHTS 2
        #define MAX_SHADOWS 190

        extern vec2 lights[MAX_LIGHTS];
        extern vec4 positions[MAX_SHADOWS];
        extern Image shadows[MAX_SHADOWS];

        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
            float brightness = 0.5;

            for(int i = 0; i < MAX_LIGHTS; i++) {
                vec2 light = lights[i];

                float dist = pow(distance(texture_coords, light) * 15.0, 6);
                // float dist = 4.0 * distance(texture_coords, light);

                if (dist < brightness) {
                    brightness = dist;
                }
            }

            float shadowAlpha = 0.0;
            float baseAlpha = 0.4;
            float size = 5000;

            for(int i = 0; i < MAX_SHADOWS; i++) {
                vec4 position = positions[i];
                float scaleX = 0.0155 * size / 1.0;//position.z;
                float scaleY = 0.0155 * size / 1.0;//position.w;
                float slope = position.w / position.z;

                if (position.x != 0) {
                    float alpha = 0.0;
                    vec2 scaledCoords = texture_coords * vec2(scaleX, scaleY) - vec2(scaleX * position.x, scaleY * position.y) / size - vec2(scaleX, scaleY) / 2 + vec2(position.z / 2, position.w / 2);

                    float ratio = scaledCoords.x / scaledCoords.y;

                    if (ratio < 1.0) {
                        //float dist = (scaledCoords.y / slope - scaledCoords.x) / (1 + 1 / slope);

                        //if (dist < shadowDist && dist > 0) {
                        //    scaledCoords = scaledCoords - vec2(-dist, dist);
                        //} else {
                        //    scaledCoords = scaledCoords - vec2(-shadowDist, shadowDist);
                        //}

                        // alpha = Texel(shadows[i], scaledCoords / vec2(position.z, position.w)).a * 0.8 * (shadowDist - dist * 0.6) / 1.5; // TODO TEXEL?

                        float dist = (scaledCoords.y / slope - scaledCoords.x) / (1 + 1 / slope);
                        //float diff = pow(abs(scaledCoords.y / slope - scaledCoords.x) / 2.5, 0.7);
                        //float diff = abs(scaledCoords.y / slope - scaledCoords.x) / 2.5;

                        float diff = abs(scaledCoords.y / slope - scaledCoords.x) / 2.4;

                        if (diff > 1) {
                            diff = pow(diff, 0.4);
                        }

                        scaledCoords = scaledCoords - (vec2(-1, 1) * diff);

                        alpha = Texel(shadows[i], scaledCoords / vec2(position.z, position.w)).a * (1 - diff * 0.7) * baseAlpha;
                    } else {
                        alpha = Texel(shadows[i], scaledCoords / vec2(position.z, position.w)).a * baseAlpha;
                    }

                    if (alpha > shadowAlpha) {
                        shadowAlpha = alpha;
                    }
                }
            }

            return vec4(0.0, 0.0, 0.0, shadowAlpha);
        }
    ]]
end

--function createFOWShader()
--    return love.graphics.newShader[[
--        #define MAX_LIGHTS 10
--
--        extern vec2 lights[MAX_LIGHTS];
--        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
--            float brightness = 0.5;
--
--            for(int i = 0; i < MAX_LIGHTS; i++) {
--                vec2 light = lights[i];
--
--                float dist = pow(distance(texture_coords, light) * 15.0, 6);
--                // float dist = 4.0 * distance(texture_coords, light);
--
--                if (dist < brightness) {
--                    brightness = dist;
--                }
--            }
--
--            return vec4(0.0, 0.0, 0.0, brightness);
--        }
--    ]]
--end

-- [[
--        extern vec2 light;
--        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
--            float pct = 0.0;
--            pct = distance(texture_coords,light);
--
--            return vec4(pct, 0.8);
--        }
--    ]]