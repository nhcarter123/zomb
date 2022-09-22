function createBunker(gridX, gridY)
    local building = createBuilding(gridX, gridY, 0, 0, BUNKER_IMAGE)

    building.shape = {
        {1},
    }

    building:setGrid()

    return building
end