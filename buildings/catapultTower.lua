return {
    create = function(gridX, gridY)
        local building = Tower.create(gridX, gridY)

        building.title = "Catapult tower"
        building.description = "Attacks enemies"
        building.cost = {{ "Wood", 25 }, { "Stone", 10 } }
        building.range = 13
        building.gun = Catapult.create()

        building.getStats = function(self)
            return {
                "Range: "..tostring(self.range),
                "Area damage: "..tostring(12),
            }
        end

        building:getAOE()

        return building
    end
}