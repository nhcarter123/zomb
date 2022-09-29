function getTowerTitle()
    return "Tower"
end

function getTowerDescription()
    return "Attacks nearby zombies"
end

function createOutpost(gridX, gridY)
    local building = createBuilding(gridX, gridY, 0, 0, TOWER_IMAGE)

    building.title = getTowerTitle()
    building.description = getTowerDescription()
    building.connectsWithWall = true
    building.scale = 0.5
    building.shape = {
        {1},
    }

    building:setGrid()
    building:setWallImages(gridX, gridY)

    for i = 1, 2 do
        for j = 1, 2 do
            local archer = createArcher(building.x + (i - 1.5) * GRID_SIZE * 0.5, building.y + (j - 1.5) * GRID_SIZE * 0.5, ARCHER_IMAGE)
            archer.building = building
            table.insert(playerUnits, archer)
            table.insert(building.occupants, archer)
        end
    end

    return building
end