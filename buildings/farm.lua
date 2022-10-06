return {
    create = function(gridX, gridY)
        local building = Building.create(gridX, gridY, 0.5, 0.5, FARM_IMAGE)

        building.title = "Farm"
        building.description = "Grows food"

        building.progress = 0
        building.updateRate = 1
        building.completeAmount = 4
        building.harvestYield = 1
        building.needsWorker = true

        building.scale = 0.5
        building.drawShadow = function() end
        building.shape = {
            {1, 1},
            {1, 1},
        }

        building.getStats = function(self)
            return {
                "Growth rate: "..tostring(self.updateRate).." / hour",
                "Growth: "..tostring(roundDecimal(self.progress, 2)),
                "Maturity Growth: "..tostring(self.completeAmount),
                "Food per harvest: "..tostring(self.harvestYield)
            }
        end

        local parentUpdate = building.update
        building.update = function(self, dt)
            if parentUpdate(self) then
                return true
            end

            if not self.noWorker then
                self.progress = self.progress + self.updateRate * dt
                self.pct = self.progress / self.completeAmount

                if self.pct >= 1 then
                    self.progress = 0
                    FOOD = FOOD + self.harvestYield
                end
            end
        end

        return building
    end
}