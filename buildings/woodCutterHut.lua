isTree = function(tile)
    if tile.building then
        return tile.building.isTree
    end
end

isStorage = function(tile)
    if tile.building then
        return tile.building.isStorage
    end
end

return {
    create = function(gridX, gridY)
        local building = Building.create(gridX, gridY, 0, 0, WOOD_CUTTER_HUT_IMAGE)

        building.title = "Wood cutter hut"
        building.description = "Gathers wood from nearby trees"
        building.cost = {{ "Wood", 5 }}
        building.shape = {
            {1},
        }
        building.scale = 0.5
        building.progress = 0
        building.updateRate = 1 * PRODUCTION_MULTIPLIER
        building.completeAmount = 1
        building.harvestYield = 1
        building.needsWorker = true
        building.isWoodCutterHut = true
        building.foodCost = 1 -- todo replace with more sophisticated solution in the future

        building.getUpdateRate = function(self)
            return self.updateRate * (1 + #self.affectedBy)
        end

        building.getStats = function(self)
            local stats = {
                "Wood production: "..tostring(self:getUpdateRate() / self.completeAmount).." / hour",
                "Food cost: "..tostring(self.foodCost).." / harvest",
            }

            if self.targets[1] then
                table.insert(stats, "Current Tree Remaining wood: "..tostring(self.targets[1].wood))
            end

            return stats
        end

        building.getAOE = function(self)
            local tiles, targets = getGridCircle(self.gridX, self.gridY, 8, isTree, 0, 0)
            local closest = getClosest(self.gridX * GRID_SIZE, self.gridY * GRID_SIZE, targets)
            if closest then
                self.targets = { closest }
            else
                self.targets = {}
            end
            self.aoe = tiles
        end

        local parentUpdate = building.update
        building.update = function(self, dt)
            if parentUpdate(self) then
                return true
            end

            if self.targets[1] and self.hasWorker and not self.forbid and WOOD_SPACE_AVAILABLE then
                if not self.paid then
                    if FOOD > 0 then
                        FOOD = FOOD - self.foodCost
                        self.paid = true
                    else
                        self.progress = 0
                        self.pct = nil
                    end
                else
                    if self.targets[1].wood <= 0 then
                        self:getAOE()
                        self.progress = 0
                    end

                    self.progress = self.progress + self:getUpdateRate() * dt
                    self.pct = self.progress / self.completeAmount

                    if self.pct >= 1 then
                        self.progress = 0
                        self.paid = false
                        local deltaWood = math.min(self.harvestYield, self.targets[1].wood)
                        self.targets[1].wood = self.targets[1].wood - deltaWood
                        WOOD = WOOD + deltaWood

                        updateStorage()

                        if self.targets[1].wood == 0 then
                            self.targets[1].health = 0
                        end
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