function createBullet(x, y, z, xVel, yVel, zVel, duration, angle, target, isHit, ammo)
    return {
        x = x,
        y = y,
        z = z,
        xVel = xVel,
        yVel = yVel,
        zVel = zVel,
        angle = 0,
        age = 0,
        angle = angle,
        originX = ammo.image:getWidth() / 2,
        originY = ammo.image:getHeight() / 2,
        target = target,
        duration = duration,
        isHit = isHit,
        ammo = ammo,

        update = function(self, dt)
            self.x = self.x + self.xVel * dt
            self.y = self.y + self.yVel * dt
            self.z = self.z + self.zVel * dt
            self.zVel = self.zVel - WORLD_GRAVITY * dt

            self.age = self.age + dt
            self.scale = self.ammo.scale * (1 + (self.z / 500))

            if self.age >= self.duration then
                if self.ammo.explosion then
                    table.insert(explosions, createExplosion(self.x, self.y, EXPLOSION_IMAGE))
                elseif self.isHit then
                    self.target.health = self.target.health - self.ammo.damage
                end

                return true -- flag for deletion
            end
        end,

        draw = function(self)
            if self.z > 0 then
                love.graphics.setColor(0, 0, 0, 0.4 / ((self.z + 200) / 200))
                love.graphics.draw(self.ammo.image, self.x, self.y, self.angle, self.ammo.scale, self.ammo.scale, self.originX, self.originY)
                love.graphics.setColor(1, 1, 1)
            end

            love.graphics.draw(self.ammo.image, self.x, self.y - self.z, self.angle, self.ammo.scale, self.ammo.scale, self.originX, self.originY)
        end
    }
end