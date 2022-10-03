return {
    getTitle = function()
        return "House"
    end,

    getDescription = function()
        return "Houses 4 people"
    end,

    create = function(self, gridX, gridY)
        local building = Building.create(gridX, gridY, 0, 0.5, HOUSE_2_IMAGE)

        building.title = self:getTitle()
        building.description = self:getDescription()
        building.shape = {
            {1},
            {1}
        }
        building.scale = 0.5
        building:setGrid()

        MAX_POPULATION = MAX_POPULATION + 4

        return building
    end
}