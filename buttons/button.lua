function createButton(contentImage)
    local backImage = BUTTON_IMAGE

    local button = {
        scale = 1,
        baseContentScale = 1,
        backImage = backImage,
        halfWidth = backImage:getWidth() / 2,
        halfHeight = backImage:getHeight() / 2,
        contentImage = contentImage,
        halfContentWidth = contentImage:getWidth() / 2,
        halfContentHeight = contentImage:getHeight() / 2,
        hovered = false,

        update = function(self, x, y)
            self.x = x
            self.y = y
            self.hovered = false
            local mx, my = love.mouse.getPosition()

            if
                mx < self.x + self.halfWidth and mx > self.x - self.halfWidth and
                my < self.y + self.halfHeight and my > self.y - self.halfHeight
            then
                self.hovered = true
            end

            local targetScale = 1
            if self.hovered then
                targetScale = 1.1
            end

            self.scale = lerp(self.scale, targetScale, 0.1)
        end,

        draw = function(self)
            love.graphics.draw(self.backImage, self.x, self.y, self.angle, 0.7 * self.scale, 0.7 * self.scale, self.halfWidth, self.halfHeight)
            love.graphics.draw(self.contentImage, self.x, self.y, self.angle, self.baseContentScale * self.scale, self.baseContentScale * self.scale, self.halfContentWidth, self.halfContentHeight)
        end
    }

    return button
end