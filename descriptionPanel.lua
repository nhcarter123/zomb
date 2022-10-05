local descriptionPanel = {
    x = 20,
    y = 400,
    width = 260,
    height = 350,
    padding = 10,
    borderSize = 2,
    title = "Farm",
    linePadding = 10,
    description = "Produces 1 food / day",

    setVisible = function(self, visible)
        self.visible = visible
    end,

    setInfo = function(self, title, description, cost, stats)
        self.title = title
        self.description = description
        self.cost = cost
        self.stats = stats
    end,

    draw = function(self)
        if self.visible then
            local writeHeight = 0

            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
            love.graphics.setColor(0.3, 0.3, 0.3)
            love.graphics.rectangle("fill", self.x + self.borderSize, self.y + self.borderSize, self.width - self.borderSize * 2, self.height - self.borderSize * 2)
            love.graphics.setColor(1, 1, 1)

            writeHeight = writeHeight + 10
            love.graphics.print(self.title, self.x + 10, self.y + writeHeight)

            writeHeight = writeHeight + 30

            if self.cost then
                love.graphics.setColor(0.2, 0.2, 0.2)
                love.graphics.line(self.x + self.linePadding, self.y + writeHeight, self.x + self.width - self.linePadding, self.y + writeHeight)
                love.graphics.setColor(1, 1, 1)

                writeHeight = writeHeight + 10
                love.graphics.print("Cost: ", self.x + self.padding, self.y + writeHeight)

                writeHeight = writeHeight + 20
                for i = 1, #self.cost do
                    love.graphics.print(tostring(self.cost[i][2]).." "..self.cost[i][1], self.x + self.padding, self.y + writeHeight)
                    writeHeight = writeHeight + 20
                end
            end

            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.line(self.x + self.linePadding, self.y + writeHeight, self.x + self.width - self.linePadding, self.y  + writeHeight)
            love.graphics.setColor(1, 1, 1)

            writeHeight = writeHeight + 10
            love.graphics.printf(self.description, self.x + self.padding, self.y + writeHeight, self.width - self.padding * 2)

            if self.stats then
                writeHeight = writeHeight + 25
                love.graphics.setColor(0.2, 0.2, 0.2)
                love.graphics.line(self.x + self.linePadding, self.y + writeHeight, self.x + self.width - self.linePadding, self.y + writeHeight)
                love.graphics.setColor(1, 1, 1)

                writeHeight = writeHeight + 10
                for i = 1, #self.stats do
                    love.graphics.printf(self.stats[i], self.x + self.padding, self.y + writeHeight, self.width - self.padding * 2)
                    writeHeight = writeHeight + 20
                end
            end
        end
    end,
}

return descriptionPanel