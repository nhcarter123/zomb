return {
    create = function(gridX, gridY)
        local building = Building.create(gridX, gridY, 0, 0.5, HOUSE_2_IMAGE)

        building.title = "House"
        building.description = "A simple home"
        building.scale = 0.5
        building.progress = 0
        building.updateRate = 3
        building.residentCount = 0
        building.residentCapacity = 4
        building.completeAmount = 24
        building.happiness = 55
        building.isHouse = true
        building.cost = {{ "Wood", 5 }}
        building.shape = {
            {1},
            {1}
        }

        local parentInit = building.init
        building.init = function(self)
            parentInit(self)
            MAX_POPULATION = MAX_POPULATION + self.residentCapacity
        end

        building.getStats = function(self)
            local stats = {
                "Capcity: "..tostring(self.residentCapacity),
            }

            if self.initialized then
                table.insert(stats, "Residents: "..tostring(self.residentCount))
                table.insert(stats, "Food consumed: "..tostring(self.residentCount * self.updateRate).." / day")
                table.insert(stats, "Happiness: "..tostring(self.happiness))
            end

            return stats
        end

        local parentUpdate = building.update
        building.update = function(self, dt)
            if parentUpdate(self) then
                return true
            end

            if self.residentCount > 0 then
                self.progress = self.progress + self.updateRate * dt
                self.pct = self.progress / self.completeAmount

                if self.pct >= 1 then
                    self.progress = 0
                    FOOD = FOOD - self.residentCount
                end
            else
                self.progress = 0
                self.pct = nil
            end
        end

        return building
    end
}