return {
    create = function(gridX, gridY)
        local building = Tower.create(gridX, gridY)

        building.title = "Catapult tower"
        building.description = "Attacks enemies"
        building.cost = {{ "Wood", 6 }, { "Stone", 6 } }
        building.range = 11
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