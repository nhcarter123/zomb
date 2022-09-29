function getHouseTitle()
    return "House"
end

function getHouseDescription()
    return "Houses 4 people"
end

function createHouse(gridX, gridY)
    local building = createBuilding(gridX, gridY, 0, 0.5, HOUSE_2_IMAGE)

    building.title = getHouseTitle()
    building.description = getHouseDescription()
    building.shape = {
        {1},
        {1}
    }
    building.scale = 0.5
    building:setGrid()

    MAX_POPULATION = MAX_POPULATION + 4

    return building
end