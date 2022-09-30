local DayManager = {
    day = 1,
    time = 12,
    isTransitioning = false,

    nextDay = function(self)
        self.isTransitioning = true
        self.looped = false
    end,

    update = function(self, dt)
        if self.isTransitioning then
            self.time = self.time + dt * 8

            if self.time > 24 then
                self.time = self.time - 24
                self.looped = true
            end

            if self.time > 12 and self.looped then
                self.time = 12
                self.isTransitioning = false
            end
        end
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