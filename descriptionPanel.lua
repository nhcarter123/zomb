local descriptionPanel = {
    x = 20,
    y = 400,
    width = 200,
    height = 350,
    padding = 10,
    title = "Farm",
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
            love.graphics.setColor(1, 1, 1)

            writeHeight = writeHeight + 10
            love.graphics.print(self.title, self.x + self.width / 2, self.y + writeHeight)

            writeHeight = writeHeight + 30

            if self.cost then
                love.graphics.line(self.x, self.y + writeHeight, self.x + self.width, self.y + writeHeight)

                writeHeight = writeHeight + 10
                love.graphics.print("Cost: ", self.x + self.padding, self.y + writeHeight)

                writeHeight = writeHeight + 20
                for i = 1, #self.cost do
                    love.graphics.print(tostring(self.cost[i][2]).." "..self.cost[i][1], self.x + self.padding, self.y + writeHeight)
                    writeHeight = writeHeight + 20
                end
            end

            love.graphics.line(self.x, self.y + writeHeight, self.x + self.width, self.y  + writeHeight)

            writeHeight = writeHeight + 10
            love.graphics.printf(self.description, self.x + self.padding, self.y + writeHeight, self.width - self.padding * 2)

            if self.stats then
                writeHeight = writeHeight + 30
                love.graphics.line(self.x, self.y + writeHeight, self.x + self.width, self.y + writeHeight)

                writeHeight = writeHeight + 10
                for i = 1, #self.stats do
                    love.graphics.print(self.stats[i], self.x + self.padding, self.y + writeHeight)
                    writeHeight = writeHeight + 20
                end
            end
        end
    end,
}

return descriptionPanel