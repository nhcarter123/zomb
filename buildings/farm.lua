return {
    create = function(gridX, gridY)
        local building = Building.create(gridX, gridY, 0.5, 0.5, FARM_IMAGE)

        building.title = "Farm"
        building.description = "Grows food"

        building.progress = 0
        building.updateRate = 2 * PRODUCTION_MULTIPLIER
        building.completeAmount = 3
        building.harvestYield = 3
        building.needsWorker = true
        building.isFarm = true

        building.scale = 0.5
        building.height = 0
        building.cost = {{ "Wood", 5 }}
        building.shape = {
            {1, 1},
            {1, 1},
        }

        building.getStats = function(self)
            return {
                "Growth rate: "..tostring(self:getUpdateRate()).." / hour",
                "Growth: "..tostring(roundDecimal(self.progress, 2)),
                "Maturity Growth: "..tostring(self.completeAmount),
                "Food per harvest: "..tostring(self.harvestYield)
            }
        end

        building.getUpdateRate = function(self)
            return self.updateRate * (1 + #self.affectedBy)
        end

        local parentUpdate = building.update
        building.update = function(self, dt)
            if parentUpdate(self) then
                return true
            end

            if self.hasWorker and not self.forbid and FOOD_SPACE_AVAILABLE then
                self.progress = self.progress + self:getUpdateRate() * dt
                self.pct = self.progress / self.completeAmount

                if self.pct >= 1 then
                    self.progress = 0
                    FOOD = FOOD + self.harvestYield
                end
            else
                self.progress = 0
                self.pct = nil
            end
        end

        return building
    end
}