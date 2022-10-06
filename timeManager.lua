formatTime = function(time)
    local formattedTime = tostring(math.floor(time))..":"

    local minutes = math.floor((time % 1) * 60)

    if minutes < 10 then
        formattedTime = formattedTime.."0"
    end

    formattedTime = formattedTime..tostring(minutes)

    return formattedTime
end

local TimeManager = {
    day = 1,
    time = 10,
    timeScale = 3,
    isTransitioning = false,
    shadowLength = 0,
    paused = false,

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

        self.shadowLength = -math.sin((x + 20) * math.pi / 16) / 3
        DropShadowShader:send("shadowLength", self.shadowLength)
    end,

    update = function(self, dt)
--        if self.isTransitioning then
--            self.time = self.time + dt * 10
--
--            if self.time > 24 then
--                self.time = self.time - 24
--                self.day = self.day + 1
--                self.looped = true
--            end
--
--            if self.time > 10 and self.looped then
--                self.time = 10
--                self.isTransitioning = false
--
--                for i = #buildings, 1, -1 do
--                    buildings[i]:nextDay()
--                end
--            end
--        elseif self.time < 14 then
--            self.time = self.time + dt / 128
--        end
        if self.paused then
            dt = 0
        else
            dt = math.pow(2, self.timeScale - 1) * dt / 16
        end


        self.time = self.time + dt

        if self.time > 24 then
            self.time = self.time - 24
            self.day = self.day + 1
        end

        self:setShadowLength()

        return dt
    end,

    draw = function(self)
        local x = self.time
        if self.time >= 21 or self.time <= 3 then
            x = 21
        end

        local brightness = (1 + math.sin(math.pi * (x + 1.5) / 9)) / 3.4
--        love.graphics.setColor(0, 0, 0, brightness)
--        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
--        love.graphics.setColor(1, 1, 1)
        FOW_SHADER:send("ambient", brightness)


        love.graphics.print("Day: "..tostring(self.day), love.graphics.getWidth() - 120, love.graphics.getHeight() - 50)
        love.graphics.print("Time: "..formatTime(self.time), love.graphics.getWidth() - 120, love.graphics.getHeight() - 35)
    end
}

return TimeManager