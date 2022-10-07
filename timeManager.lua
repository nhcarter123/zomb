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
    timeScale = 2,
    shadowLength = 0,
    shadowAngle = -0.7853981634,
    paused = false,

    setShadowLength = function(self)
--        local x = self.time
--
--        if x <= 2 then
--            x = 2
--        end
--        if x >= 22 then
--            x = 22
--        end

--        self.shadowLength = -math.sin((x + 8) * math.pi / 20) / 3
        self.shadowLength = 0.044 * math.abs(self.time - 12)
        local angle = self.shadowAngle

        if self.time > 12 then
           angle = angle + toRad(180)
        end

        DropShadowShader:send("shadow", { self.shadowLength, angle })
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
            dt = math.pow(2, self.timeScale - 1) * dt / 8
        end


        self.time = self.time + dt

        if self.time > 24 then
            self.time = self.time - 24
            self.day = self.day + 1
        end

--        self.shadowAngle = self.shadowAngle + 1 * dt

        self:setShadowLength()

        return dt
    end,

    draw = function(self)
        local x = self.time
--        if self.time >= 21 or self.time <= 3 then
--            x = 21
--        end

        local brightness = (1 + math.sin(math.pi * (x + 10.5) / 15)) / 3.4
        love.graphics.setColor(0, 0, 0, brightness)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
--        FOW_SHADER:send("ambient", brightness)


        love.graphics.print("Day: "..tostring(self.day), love.graphics.getWidth() - 120, love.graphics.getHeight() - 50)
        love.graphics.print("Time: "..formatTime(self.time), love.graphics.getWidth() - 120, love.graphics.getHeight() - 35)
    end
}

return TimeManager