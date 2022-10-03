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

    create = function(self, gridX, gridY)
        local building = Building.create(gridX, gridY, 0, 0, WOOD_CUTTER_HUT_IMAGE)

        building.title = self:getTitle()
        building.description = self:getDescription()
        building.aoe = getGridCircle(gridX, gridY, 3, isTree)
        building.shape = {
            {1},
        }
        building.scale = 0.5

        local parentPostDraw = building.postDraw
        building.postDraw = function(self)
            parentPostDraw(self)

            if self.highlighted then
                self:drawAOE()
            end
        end

        building:setGrid()


        return building
    end,
}