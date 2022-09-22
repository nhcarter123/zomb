function createHouse(gridX, gridY)
    local building = createBuilding(gridX, gridY, 0, 0.5, HOUSE_2_IMAGE)

    building.shape = {
        {1},
        {1}
    }
    building.spawnCount = 5
    building.spawnDuration = 5
    building.spawned = 0
    building.spawnTotal = 4

    building.update = function(self, dt)
        if self.health <= 0 then
            self:setGrid(true)
            for i = #self.occupants, 1, -1 do
                local occupant = self.occupants[i]
                occupant.health = 0
                table.remove(self.occupants, i)
            end

            return true -- flag for deletion
        end

        if self.spawned < self.spawnTotal then
            if self.spawnCount >= self.spawnDuration then
                self.spawnCount = 0
                self.spawned = self.spawned + 1
                POPULATION = POPULATION + 1

                local worker = createWorker(self.gridX * GRID_SIZE, self.gridY * GRID_SIZE, E_UNIT_FARMER)
                worker.targetGridX, worker.targetGridY = self:getOpenNeighborTilePos()
                table.insert(playerUnits, worker)
            end

            self.spawnCount = self.spawnCount + dt
        end
    end

    building:setGrid()

    return building
end