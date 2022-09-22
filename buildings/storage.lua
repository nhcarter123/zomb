function createStorage(gridX, gridY)
    local building = createBuilding(gridX, gridY, 0.5, 0.5, SANDBAGS_IMAGE)

    building.scale = 0.51
    building.shape = {
        {1, 1},
        {1, 1},
    }

    building:setGrid()

--    for i = 1, 2 do
--        for j = 1, 2 do
--            local soldier = createSoldier(building.x + (i - 1.5) * GRID_SIZE * 0.4, building.y + (j - 1.5) * GRID_SIZE * 0.4, createM1911(), SOLDIER_IMAGE)
--            soldier.building = building
--            table.insert(playerUnits, soldier)
--            table.insert(building.occupants, soldier)
--        end
--    end

    return building
end