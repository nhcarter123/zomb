isWoodCutterHut = function(tile)
    if tile.building then
        return tile.building.isWoodCutterHut
    end
end

return {
    create = function(gridX, gridY)
        local building = Building.create(gridX, gridY, 0.5, 0, SAWMILL_IMAGE)

        building.title = "Sawmill"
        building.description = "Increases production of nearby wood cutter huts"
        building.scale = 0.5

        building.isTotem = true
        building.cost = {{ "Wood", 10 }, { "Stone", 5 }}
        building.shape = {
            {1, 1},
        }

        building.getAOE = function(self)
            self.aoe, self.targets = getGridCircle(self.gridX, self.gridY, 2, isWoodCutterHut, self.offsetX, self.offsetY)

            if self.initialized then
                for i = 1, #self.targets do
                    local target = self.targets[i]

                    if not contains(target.affectedBy, self) then
                        table.insert(target.affectedBy, self)
                    end
                end
            end
        end

        building.getStats = function(self)
            local stats = {
                "Affected wood cutter huts: "..tostring(0),
            }

            return stats
        end

        return building
    end
}