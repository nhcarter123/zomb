return love.graphics.newShader[[
    extern float time;
    extern float scale;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {

        float brightness = 0;

        if (mod((texture_coords.y + 32 * time / scale) * scale / 16, 2) < 1) {
            brightness = 1;
        }

        return vec4(brightness, brightness, brightness, 0.4);
    }
]]