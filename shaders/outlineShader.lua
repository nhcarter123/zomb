function createOutlineShader()
    return love.graphics.newShader[[
        vec4 resultCol;
        extern vec2 stepSize;
        extern float opacity;

        vec4 effect( vec4 col, Image texture, vec2 texturePos, vec2 screenPos )
        {
            // get color of pixels:
            float alpha = 4*texture2D( texture, texturePos ).a;
            float right = 0;
            float left = 0;
            float up = 0;
            float down = 0;

            if (texturePos.x + stepSize.x > 1.0) {
                right = 0.0;
            } else {
                right = texture2D( texture, texturePos + vec2( stepSize.x, 0.0f ) ).a;
            }

            if (texturePos.x - stepSize.x < 0.0) {
                left = 0.0;
            } else {
                left = texture2D( texture, texturePos + vec2( -stepSize.x, 0.0f ) ).a;
            }

            if (texturePos.y + stepSize.y > 1.0) {
                down = 0.0;
            } else {
                down = texture2D( texture, texturePos + vec2( 0.0f, stepSize.y ) ).a;
            }

            if (texturePos.y - stepSize.y < 0.0) {
                up = 0.0;
            } else {
                up = texture2D( texture, texturePos + vec2( 0.0f, -stepSize.y ) ).a;
            }

            alpha -= right;
            alpha -= left;
            alpha -= down;
            alpha -= up;

            // calculate resulting color
            resultCol = vec4( 1.0f, 1.0f, 1.0f, min(alpha, opacity) );
            // return color for current pixel
            return resultCol;
        }
    ]]
end

--function createOutlineShader()
--    return love.graphics.newShader[[
--        vec4 resultCol;
--        extern vec2 stepSize;
--
--        vec4 effect( vec4 col, Image texture, vec2 texturePos, vec2 screenPos )
--        {
--            // get color of pixels:
--            float alpha = 4*texture2D( texture, texturePos ).a;
--            alpha -= texture2D( texture, texturePos + vec2( stepSize.x, 0.0f ) ).a;
--            alpha -= texture2D( texture, texturePos + vec2( -stepSize.x, 0.0f ) ).a;
--            alpha -= texture2D( texture, texturePos + vec2( 0.0f, stepSize.y ) ).a;
--            alpha -= texture2D( texture, texturePos + vec2( 0.0f, -stepSize.y ) ).a;
--
--            // calculate resulting color
--            resultCol = vec4( 1.0f, 1.0f, 1.0f, min(alpha, 0.7f) );
--            // return color for current pixel
--            return resultCol;
--        }
--    ]]
--end
