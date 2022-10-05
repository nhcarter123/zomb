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
        building.shape = {
            {1},
        }
        building.scale = 0.5
        building.woodProduction = 1

        building.getStats = function(self)
            local stats = {
                "Wood production: "..tostring(self.woodProduction).." / day",
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

        building:getAOE()

        return building
    end,
}