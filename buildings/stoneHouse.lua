return {
    create = function(gridX, gridY)
        local building = Building.create(gridX, gridY, 1, 0, STONE_HOUSE)

        building.title = "Stone house"
        building.description = "A solid, well built home"
        building.scale = 0.5
        building.residentCount = 10
        building.isHouse = true
        building.cost = {{ "Wood", 10 }, { "Stone", 15 }}
        building.shape = {
            {1, 1, 1},
        }

        local parentInit = building.init
        building.init = function(self)
            POPULATION = POPULATION + self.residentCount

            parentInit(self)
        end

        building.getStats = function(self)
            local stats = {
                "Residents: "..tostring(self.residentCount),
            }
            return stats
        end

        return building
    end
}