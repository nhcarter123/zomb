getUnitImageFromType = function(type)
    if type == E_UNIT_FARMER then
        return SOLDIER_IMAGE
    end

    if type == E_UNIT_SOLDIER then
        return SOLDIER_IMAGE
    end

    if type == E_UNIT_ZOMBIE then
        return ZOMBIE_IMAGE
    end
end

function createUnit(x, y, type)
    local maxHealth = 100
    local image = getUnitImageFromType(type)

    return {
        state = 'sentry',
        x = x,
        y = y,
        type = type,
        angle = 0,
        target = nil,
        size = 30,
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