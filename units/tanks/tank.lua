function createTank(x, y, isPlayer, gun, image, turretImage)
    local unit = createUnit(x, y, isPlayer, gun, image, false)

    unit.turretAngle = unit.angle
    unit.turretImage = turretImage

--    unit.update = function(self, dt, time)
--        self.unitUpdate(self, dt, time)
--        self.turretAngle = lerp(self.turretAngle, self.angle, 0.01)
--    end

    unit.draw = function(self)
        love.graphics.draw(self.image, self.x, self.y, self.angle, 1, 1, self.originX, self.originY)
        love.graphics.draw(self.turretImage, self.x, self.y, self.turretAngle, 1, 1, self.originX, self.originY)
        self.drawHealthbar(self)
    end

    return unit
end