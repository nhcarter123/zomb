return {
    create = function(gridX, gridY)
        local building = Building.create(gridX, gridY, 0.5, 0.5, FARM_IMAGE)

        building.title = "Farm"
        building.description = "Grows food"
        building.cropGrowth = 0
        building.cropGrowthRate = 1
        building.cropGrowthTotal = 4
        building.harvestYield = 8
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

            if self.highlighted == 2 then
                love.graphics.setColor(0.2, 0.2, 0.2)
                love.graphics.rectangle("fill", self.x - self.cropWidth / 2, self.y - self.cropHeight / 2, self.cropWidth, self.cropHeight)
                love.graphics.setColor(0.5, 0.75, 0.5)
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
                "Growth rate: "..tostring(self.cropGrowthRate).." / day",
                "Growth: "..tostring(self.cropGrowth),
                "Maturity growth: "..tostring(self.cropGrowthTotal),
                "Food per harvest: "..tostring(self.harvestYield)
            }
        end

        return building
    end
}