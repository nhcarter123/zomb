local DayManager = {
    day = 1,
    time = 10,
    isTransitioning = false,
    shadowLength = 0,

    nextDay = function(self)
        self.isTransitioning = true
        self.looped = false
    end,

    setShadowLength = function(self)
        local x = self.time

        if x <= 4 then
            x = 4
        end
        if x >= 20 then
            x = 20
        end

        self.shadowLength = -math.sin((x + 20) * math.pi / 16) / 2.5
        DropShadowShader:send("shadowLength", self.shadowLength)
    end,

    update = function(self, dt)
        if self.isTransitioning then
            self.time = self.time + dt * 6

            if self.time > 24 then
                self.time = self.time - 24
                self.looped = true
            end

            if self.time > 10 and self.looped then
                self.time = 10
                self.isTransitioning = false
            end
        elseif self.time < 14 then
            self.time = self.time + dt / 128
        end

        self:setShadowLength()
    end,

    draw = function(self)
        if self.isTransitioning then
            local x = self.time
            if self.time >= 21 or self.time <= 3 then
                x = 21
            end

            local brightness = (1 + math.sin(math.pi * (x + 1.5) / 9)) / 2.8
            love.graphics.setColor(0, 0, 0, brightness)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            love.graphics.setColor(1, 1, 1)
        end
    end
}

return DayManager