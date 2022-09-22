function createGun(magazineSize, fireDelay, reloadDurtion, accuracy, velocityMod, minRange, maxRange, weight, ammo)
    local fire = function(self, x, y, missX, missY, isHit, angle, distToTarget, target)
        local speedFactor = self.ammo.velocity * self.velocityMod
        local duration = distToTarget / speedFactor

        local xVel = (target.x + missX - x) / duration
        local yVel = (target.y + missY - y) / duration

        return createBullet(x, y, 0, xVel, yVel, 0, duration, angle, target, isHit, self.ammo)
    end

    return {
        minRange = minRange,
        maxRange = maxRange,
        magazineSize = magazineSize,
        magazineCount = magazineSize,
        weight = weight,
        ammo = ammo,
        velocityMod = velocityMod,
        reloadDurtion = reloadDurtion,
        reloadCount = 0,
        accuracy = accuracy,
        fireDelay = fireDelay,
        fireCount = fireDelay,

        fire = fire,

        pullTrigger = function(self, dt, x, y, angle, distToTarget, target)
            if self.magazineCount > 0 then
                if self.fireCount >= self.fireDelay then
                    self.fireCount = 0
                    self.magazineCount = self.magazineCount - 1

                    local missX = (math.random() - 0.5) * self.accuracy * distToTarget
                    local missY = (math.random() - 0.5) * self.accuracy * distToTarget
                    local missBy = dist(target.x, target.y, target.x + missX, target.y + missY)

                    local isHit = false
                    if missBy < target.size then
                        isHit = true
                    end

                    table.insert(bullets, self.fire(self, x, y, missX, missY, isHit, angle, distToTarget, target))
                else
                    self.fireCount = self.fireCount + dt
                end
            elseif self.reloadCount >= self.reloadDurtion then
                self.magazineCount = self.magazineSize
                self.reloadCount = 0
            else
                self.reloadCount = self.reloadCount + dt
            end
        end
    }
end