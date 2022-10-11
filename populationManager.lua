return {
    progress = 0,
    updateRate = 2,
    completeAmount = 24,
    xPadding = 6,
    barHeight = 8,

    update = function(self, dt)
        if POPULATION < MAX_POPULATION then
            self.updateRate = 2
            self.progress = self.progress + self.updateRate * dt
            self.pct = self.progress / self.completeAmount

            if self.pct >= 1 then
                self.progress = 0
                POPULATION = POPULATION + 1
                setWorkers()
            end
        else
            self.updateRate = 0
            self.progress = 0
            self.pct = nil
        end
    end,

    draw = function(self)
        local x = 300
        local y = 30
        local width = 100
        local offsetY = 25

        love.graphics.print("Birth rate: "..tostring(roundDecimal(self.updateRate)).." / day", x, y)

        if self.pct then
            love.graphics.setColor(0.2, 0.2, 0.2, 1)
            love.graphics.rectangle("fill", x, y - self.barHeight / 2 + offsetY, width - self.xPadding * 2, self.barHeight)
            love.graphics.setColor(0.7, 0.7, 0.7, 1)
            love.graphics.rectangle(
                "fill",
                x + 2,
                y + 2 - self.barHeight / 2 + offsetY,
                self.pct * (width - 4 - self.xPadding * 2),
                self.barHeight - 4
            )
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.draw(WARNING_IMAGE, x + 130, y + 8, 0, 0.25, 0.25, ICON_ORIGIN_X, ICON_ORIGIN_Y)
        end
    end
}