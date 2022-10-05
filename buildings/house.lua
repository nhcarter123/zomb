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

        local parentInit = building.init
        building.init = function(self)
            parentInit(self)
            MAX_POPULATION = MAX_POPULATION + 4
        end

        return building
    end
}