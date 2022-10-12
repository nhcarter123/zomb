function createExplosion(x, y, image)
    return {
        x = x,
        y = y,
        originX = 24,
        originY = 24,
        animation = createAnimation(image, 48, 48, 1),
        dealtDamage = false,
        radius = 60,
        damage = 4000,

        update = function(self, dt)
            dt = dt * 12
            if not self.dealtDamage then
                self.dealtDamage = true

                local hits = getWithinRadius(self.x, self.y, self.radius, enemyUnits)

                for i = 1, #hits, 1 do
                    local hit = hits[i]

                    local dist = dist(self.x, self.y, hit.x, hit.y)
                    hit.health = hit.health - self.damage  / (dist + 120)
                end
            end

            self.animation.currentTime = self.animation.currentTime + dt * 2
            if self.animation.currentTime >= self.animation.duration then
                -- maybe need this for animation looping
                -- self.animation.currentTime = self.animation.currentTime - self.animation.duration
                return true
            end
        end,

        draw = function(self)
            love.graphics.setColor(1, 1, 1, 0.5)
            local spriteNum = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.quads) + 1
            love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], self.x, self.y, 0, self.radius / 40, self.radius / 40, self.originX, self.originY)

            local percentComplete = clamp(0, 4 * self.animation.currentTime / self.animation.duration, 1)

            if percentComplete < 1 then
                love.graphics.setColor(1, 1, 1, 0.5 - 0.5 * percentComplete)
                love.graphics.circle("fill", self.x, self.y, (self.radius / 40) * percentComplete * self.radius, 16)
                love.graphics.setColor(1, 1, 1)
            end
        end
    }
end