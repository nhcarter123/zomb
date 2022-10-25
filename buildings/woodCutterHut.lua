isTree = function(tile)
    if tile.building then
        return tile.building.isTree
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
        building.foodCost = 1 -- todo replace with more sophisticated solution in the future

        building.getStats = function(self)
            local stats = {
                "Wood production: "..tostring(self.updateRate / self.completeAmount).." / hour",
                "Food cost: "..tostring(self.foodCost).." / harvest",
            }

            if self.closestTarget then
                table.insert(stats, "Current Tree Remaining wood: "..tostring(self.closestTarget.wood))
            end

            return stats
        end

        building.getAOE = function(self)
            local tiles, targets = getGridCircle(self.gridX, self.gridY, 5, isTree)
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

            if self.closestTarget and self.hasWorker and not self.forbid and WOOD_SPACE_AVAILABLE then
                if not self.paid then
                    if FOOD > 0 then
                        FOOD = FOOD - self.foodCost
                        self.paid = true
                    else
                        self.progress = 0
                        self.pct = nil
                    end
                else
                    if self.closestTarget.wood <= 0 then
                        self:getAOE()
                        self.progress = 0
                    end

                    self.progress = self.progress + self.updateRate * dt
                    self.pct = self.progress / self.completeAmount

                    if self.pct >= 1 then
                        self.progress = 0
                        self.paid = false
                        local deltaWood = math.min(self.harvestYield, self.closestTarget.wood)
                        self.closestTarget.wood = self.closestTarget.wood - deltaWood
                        WOOD = WOOD + deltaWood

                        updateStorage()

                        if self.closestTarget.wood == 0 then
                            self.closestTarget.health = 0
                        end
                    end
                end
            else
                self.progress = 0
                self.pct = nil
            end
        end

--        building.nextDay = function(self)
--            if self.closestTarget and self.closestTarget.wood > 0 then
--                local deltaWood = math.min(self.woodProduction, self.closestTarget.wood)
--                self.closestTarget.wood = self.closestTarget.wood - deltaWood
--                WOOD = WOOD + deltaWood
--            end
--        end

        building:getAOE()

        return building
    end,
}