isTree = function(tile)
    if tile.building then
        return tile.building.isTree
    end
end

return {
    getTitle = function()
        return "Wood cutter hut"
    end,

    getDescription = function()
        return "Gathers wood from nearby trees"
    end,

    getAOE = function(gridX, gridY)
        local tiles, targets = getGridCircle(gridX, gridY, 5, isTree)
        local closestTarget = getClosest(gridX * GRID_SIZE, gridY * GRID_SIZE, targets)

        return tiles, closestTarget
    end,

    create = function(self, gridX, gridY)
        local building = Building.create(gridX, gridY, 0, 0, WOOD_CUTTER_HUT_IMAGE)

        building.title = self:getTitle()
        building.description = self:getDescription()
        building.aoe, building.closestTarget = self.getAOE(gridX, gridY)
        building.shape = {
            {1},
        }
        building.scale = 0.5

        local parentPostDraw = building.postDraw
        building.postDraw = function(self)
            parentPostDraw(self)

            if self.highlighted == 2 then
                drawAOE(self.aoe, self.x, self.y, self.closestTarget)
            end
        end

        building:setGrid()


        return building
    end,
}