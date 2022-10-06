return {
    create = function(gridX, gridY)
        local building = Building.create(gridX, gridY, 0, 0.5, HOUSE_2_IMAGE)

        building.title = "House"
        building.description = "Houses 4 people"
        building.shape = {
            {1},
            {1}
        }
        building.scale = 0.5
        building.progress = 0
        building.updateRate = 1
        building.completeAmount = 12
        building.baseBirthChance = 0.15
        building.foodConsumed = 4
        building.happiness = 55

        local parentInit = building.init
        building.init = function(self)
            parentInit(self)
            MAX_POPULATION = MAX_POPULATION + 4
        end

        building.getStats = function(self)
            return {
                "Birth chance: "..tostring(self.baseBirthChance * 100).."%",
                "Happiness: "..tostring(self.happiness),
                "Food consumed: "..tostring(self.foodConsumed).." / day"
            }
        end

        local parentUpdate = building.update
        building.update = function(self, dt)
            if parentUpdate(self) then
                return true
            end

            self.progress = self.progress + self.updateRate * dt
            self.pct = self.progress / self.completeAmount

            if self.pct >= 1 then
                self.progress = 0
                FOOD = FOOD - self.foodConsumed

                if POPULATION < MAX_POPULATION and math.random() > self.baseBirthChance then
                    POPULATION = POPULATION + 1
                end
            end
        end

        return building
    end
}