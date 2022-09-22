function createM1AbramsTurret()
    local gun = createGun(
        1, -- magazine size
        0, -- shot delay
        5, -- reload time
        0.1, -- acuracy mod,
        1, -- velocity mod,
        200, -- min range
        2000, -- max range
        100, -- weight
        createTankShell() -- ammo
    )

    gun.fire = function(self, x, y, missX, missY, isHit, angle, distToTarget, target)
        local ammo = createTankShell()

        local targetX = target.x + missX
        local targetY = target.y + missY

        local dist = dist(x, y, targetX, targetY)
        local launchSpeed = self.ammo.velocity * self.velocityMod

        local input = WORLD_GRAVITY * dist / math.pow(launchSpeed, 2)

        if input <= 1 then
            local launchAngle = 0.5 * math.asin(input)
            local groundSpeed = launchSpeed * math.cos(launchAngle)
            local vz = launchSpeed * math.sin(launchAngle)

            local duration = dist / groundSpeed
            local vx = (targetX - x) / duration
            local vy = (targetY - y) / duration

            return createBullet(x, y, 0, vx, vy, vz, duration, angle, nil, false, self.ammo)
        else
            love.window.showMessageBox("test", "tank range misconfigured")
        end
    end

    return gun
end