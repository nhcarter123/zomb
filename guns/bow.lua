function createBow()
    local gun = createGun(
        4, -- magazine size
        0.05, -- shot delay
        3, -- reload time
        0.3, -- acuracy mod,
        0.7, -- velocity mod,
        0, -- min range
        600, -- max range
        1, -- weight
        createArrow() -- ammo
    )

    gun.fire = function(self, x, y, missX, missY, isHit, angle, distToTarget, target)
        local targetX = target.x + missX + distToTarget * target.vx / 4
        local targetY = target.y + missY + distToTarget * target.vy / 4

        local d = dist(x, y, targetX, targetY)

        local startHeight = 30
        local airResistance = 0
        local launchAngle = toRad(d / 40)

--        local t = 10 -- unknown

--        0 = startHeight + math.sin(launchAngle) * t - 0.5 * WORLD_GRAVITY * t * t
--        dist = math.cos(launchAngle) * t + airResistance

--        0 = startHeight + math.sin(launchAngle) * t - 0.5 * WORLD_GRAVITY * t * t
--        local t = (dist - airResistance) / (v * math.cos(launchAngle))
--        local t = d / (v * x)
--        0 = h + v * y * (d / (v * x)) - 0.5 * g * (d / (v * x))

--        math.sqrt((startHeight + (vz * (dist - airResistance) / vxy)   /   (0.5 * WORLD_GRAVITY)) = (dist - airResistance) / (v * vxy)
--        v = (dist - airResistance) / (vxy * math.sqrt((startHeight + (vz * (dist - airResistance) / vxy)   /   (0.5 * WORLD_GRAVITY)))


--        local t = (d - r) / (v * math.cos(a))
        local vxy = math.cos(launchAngle)
        local vz = math.sin(launchAngle)
--        local v = -startHeight / (math.sin(launchAngle) * t) + (0.5 * WORLD_GRAVITY * t) / math.sin(launchAngle)
--        local launchSpeed = (dist - airResistance) / (vxy * math.sqrt(((dist - airResistance) / (vxy * vz) + startHeight) / (0.5 * WORLD_GRAVITY)))
--        local launchSpeed = (dist - airResistance) / (vxy * math.sqrt(startHeight + (vz * (dist - airResistance) / vxy) / (-0.5 * WORLD_GRAVITY)))
--        local launchSpeed = -dist * (vz - math.sqrt(2 * 0.1 * startHeight + vz * vz)) / 2 * startHeight * vxy
        local launchSpeed = (d * math.sqrt(WORLD_GRAVITY)) / math.sqrt(2 * vxy * (startHeight * vxy + d * vz))

--        local input = WORLD_GRAVITY * dist / math.pow(launchSpeed, 2)
        local groundSpeed = launchSpeed * math.cos(launchAngle)
        local vz = launchSpeed * math.sin(launchAngle)

        local duration = d / groundSpeed
        local vx = (targetX - x) / duration
        local vy = (targetY - y) / duration

        return createBullet(x, y, startHeight, vx, vy, vz, duration, angle, target, isHit, self.ammo)
    end

    return gun
end