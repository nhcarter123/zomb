return {
    getTitle = function()
        return "Farm"
    end,

    getDescription = function()
        return "Grows food"
    end,

    create = function(self, gridX, gridY)
        local building = Building.create(gridX, gridY, 0.5, 0.5, FARM_IMAGE)

        building.title = self:getTitle()
        building.description = self:getDescription()
        building.cropGrowth = 0
        building.cropGrowthRate = 1
        building.cropGrowthTotal = 4
        building.cropWidth = 80
        building.cropHeight = 16
        building.scale = 0.5
        building.drawShadow = function() end
        building.shape = {
            {1, 1},
            {1, 1},
        }

        local parentDraw = building.draw

        building.draw = function(self)
            parentDraw(self)

            local pct = self.cropGrowth / self.cropGrowthTotal

            if self.highlighted then
                love.graphics.setColor(0.3, 0.3, 0.3)
                love.graphics.rectangle("fill", self.x - self.cropWidth / 2, self.y - self.cropHeight / 2, self.cropWidth, self.cropHeight)
                love.graphics.setColor(0.5, 0.65, 0.5)
                love.graphics.rectangle(
                    "fill",
                    self.x - self.cropWidth / 2 + pct * self.cropWidth / 2 + 2,
                    self.y + 2 - self.cropHeight / 2,
                    math.max(pct, 0.05) * (self.cropWidth - 4),
                    self.cropHeight - 4
                )
                love.graphics.setColor(1, 1, 1)
            end
        end

        building.getStats = function(self)
            return {
                "Growth: "..tostring(self.cropGrowth),
                "Growth rate: "..tostring(self.cropGrowthRate).." / day",
                "Maturity growth: "..tostring(self.cropGrowthTotal)
            }
        end

        building:setGrid()

        return building
    end
}