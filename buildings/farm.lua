function getFarmTitle()
    return "Farm"
end

function getFarmDescription()
    return "Produces 1 food / day"
end

function createFarm(gridX, gridY)
    local building = createBuilding(gridX, gridY, 0.5, 0.5, FARM_IMAGE)

    building.title = getFarmTitle()
    building.description = getFarmDescription()
    building.scale = 0.5
    building.shape = {
        {1, 1},
        {1, 1},
    }

    building:setGrid()

    return building
end