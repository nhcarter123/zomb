function createButton(image, title, description, cost)
    local button = {
        scale = 1,
        baseScale = 1,
        width = 80,
        height = 80,
        image = image,
        halfWidth = image:getWidth() / 2,
        halfHeight = image:getHeight() / 2,
        title = title,
        description = description,
        cost = cost,

        update = function(self, x, y, isHovered)
            self.x = x
            self.y = y


            local targetScale = 1
            if isHovered then
                targetScale = 1.1
            end

            self.scale = lerp(self.scale, targetScale, 0.1)
        end,

        draw = function(self)
            love.graphics.setColor(0.5, 0.5, 0.5)
            love.graphics.rectangle("fill", self.x -  self.scale * self.width / 2, self.y - self.scale * self.height / 2, self.width * self.scale, self.height * self.scale)
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(self.image, self.x, self.y, self.angle, self.baseScale * self.scale, self.baseScale * self.scale, self.halfWidth, self.halfHeight)
        end
    }

    return button
end