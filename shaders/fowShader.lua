function createFOWShader()
    return love.graphics.newShader[[
        #define MAX_LIGHTS 10

        extern vec2 lights[MAX_LIGHTS];
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

            return vec4(0.0, 0.0, 0.0, brightness);
        }
    ]]
end

-- [[
--        extern vec2 light;
--        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
--            float pct = 0.0;
--            pct = distance(texture_coords,light);
--
--            return vec4(pct, 0.8);
--        }
--    ]]