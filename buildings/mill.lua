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

        local parentInit = building.init
        building.init = function(self)
            parentInit(self)
            building:getAOE()
        end

        local parentPostDraw = building.postDraw
        building.postDraw = function(self)
            parentPostDraw(self)

            if self.highlighted == 2 then
                self:drawAOE()
            end
        end

        building.getStats = function(self)
            local stats = {
                "Affected farms: "..tostring(0),
            }

            return stats
        end

--        local parentUpdate = building.update
--        building.update = function(self, dt)
--            if parentUpdate(self) then
--                return true
--            end
--
--            if self.residentCount > 0 then
--                self.progress = self.progress + self.updateRate * dt
--                self.pct = self.progress / self.completeAmount
--
--                if self.pct >= 1 then
--                    self.progress = 0
--                    FOOD = FOOD - self.residentCount
--                end
--            else
--                self.progress = 0
--                self.pct = nil
--            end
--        end

        return building
    end
}