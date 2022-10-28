isFarm = function(tile)
    if tile.building then
        return tile.building.isFarm
    end
end

return {
    create = function(gridX, gridY)
        local building = Building.create(gridX, gridY, 0.5, 0.5, MILL_IMAGE)

        building.title = "Mill"
        building.description = "Increases production of nearby farms"
        building.scale = 0.5

        building.isTotem = true
        building.cost = {{ "Wood", 10 }, { "Stone", 10 }}
        building.shape = {
            {1, 1},
            {1, 1}
        }

        building.getAOE = function(self)
            self.aoe, self.targets = getGridCircle(self.gridX, self.gridY, 3, isFarm, self.offsetX, self.offsetY)

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
                "Affected farms: "..tostring(0),
            }

            return stats
        end

        return building
    end
}