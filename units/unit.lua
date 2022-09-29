function createUnit(x, y, image)
    local maxHealth = 100

    return {
        state = 'sentry',
        x = x,
        y = y,
        angle = 0,
        target = nil,
        size = 20,
        weight = 5,
        desiredRange = nil,
        health = maxHealth,
        maxHealth = maxHealth,
        originX = image:getWidth() / 2,
        originY = image:getHeight() / 2,
        image = image,
        healthBarR = 0.2,
        healthBarG = 0.9,
        healthBarB = 0.2,
        vx = 0,
        vy = 0,

        update = function(self)
            if self.health <= 0 then
                return true -- flag for deletion
            end
        end,

        draw = function(self)
            love.graphics.draw(self.image, self.x, self.y, self.angle, self.scale, self.scale, self.originX, self.originY)
        end,

        drawHealthbar = function(self)
            if self.health < self.maxHealth then
                local healthBarWidth = 40
                local percentHealth = self.health / self.maxHealth
                love.graphics.setColor(0.2, 0.2, 0.2)
                love.graphics.rectangle("fill", self.x - healthBarWidth / 2, self.y - 10, healthBarWidth, 7)
                love.graphics.setColor(self.healthBarR, self.healthBarG, self.healthBarB)
                love.graphics.rectangle("fill", self.x - healthBarWidth / 2 + 1, self.y - 9, healthBarWidth * percentHealth - 2, 5)
                love.graphics.setColor(1, 1, 1)
            end
        end
    }
end