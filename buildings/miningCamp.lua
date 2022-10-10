isBoulder = function(tile)
    if tile.building then
        return tile.building.isStone
    end
end

return {
    create = function(gridX, gridY)
        local building = Building.create(gridX, gridY, 0, 0, MINING_CAMP_IMAGE)

        building.title = "Mining camp"
        building.description = "Mines nearby boulders"
        building.scale = 0.5
        building.progress = 0
        building.updateRate = 1
        building.completeAmount = 6
        building.harvestYield = 1
        building.height = 0.5
        building.needsWorker = true
        building.cost = {{ "Wood", 5 }}
        building.shape = {
            {1},
        }

        building.getStats = function(self)
            local stats = {
                "Mining rate: "..tostring(24 * self.updateRate / self.completeAmount).." / day",
            }

            if self.closestTarget then
                table.insert(stats, "Current boulder remaining stone: "..tostring(self.closestTarget.stone))
            end

            return stats
        end

        building.getAOE = function(self)
            local tiles, targets = getGridCircle(self.gridX, self.gridY, 5, isBoulder)
            self.closestTarget = getClosest(self.gridX * GRID_SIZE, self.gridY * GRID_SIZE, targets)
            self.aoe = tiles
        end

        local parentPostDraw = building.postDraw
        building.postDraw = function(self)
            parentPostDraw(self)

            if self.highlighted == 2 then
                self:drawAOE()
            end
        end

        local parentUpdate = building.update
        building.update = function(self, dt)
            if parentUpdate(self) then
                return true
            end

            if self.closestTarget and not self.noWorker and not self.forbid and STONE_SPACE_AVAILABLE then
                if self.closestTarget.stone <= 0 then
                    self:getAOE()
                    self.progress = 0
                end

                self.progress = self.progress + self.updateRate * dt
                self.pct = self.progress / self.completeAmount

                if self.pct >= 1 then
                    self.progress = 0
                    local delta = math.min(self.harvestYield, self.closestTarget.stone)
                    self.closestTarget.stone = self.closestTarget.stone - delta
                    STONE = STONE + delta
                    updateStorage()

                    if self.closestTarget.stone == 0 then
                        self.closestTarget.health = 0
                    end
                end
            else
                self.progress = 0
                self.pct = nil
            end
        end

        building:getAOE()

        return building
    end,
}