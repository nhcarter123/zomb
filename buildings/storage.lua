function getGraneryTitle()
    return "Storage shed"
end

function getGraneryDescription()
    return "Stores resources"
end

function createStorage(gridX, gridY)
    local building = createBuilding(gridX, gridY, 0.5, 0.5, STORAGE_FLOOR_IMAGE)

    building.totalStorage = 60
    building.title = getGraneryTitle()
    building.description = getGraneryDescription()
    building.alpha = 0.25
    building.scale = 0.51
    building.shape = {
        {1, 1},
        {1, 1},
    }

    local parentUpdate = building.update

    building.update = function(self)
        parentUpdate(self)

        if HOVERED_TILE and HOVERED_TILE.building == self then
            self.alpha = clamp(0, self.alpha - 0.025, 1)
        else
            self.alpha = clamp(0, self.alpha + 0.025, 1)
        end
    end

    building.draw = function(self)
        love.graphics.draw(STORAGE_FLOOR_IMAGE, self.x, self.y, self.angle, self.scale, self.scale, self.originX, self.originY)

        if self.alpha < 1 then
            love.graphics.setColor(1, 1, 1, self.alpha)
            love.graphics.draw(STORAGE_ROOF_IMAGE, self.x, self.y, self.angle, self.scale, self.scale, self.originX, self.originY)
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.draw(STORAGE_ROOF_IMAGE, self.x, self.y, self.angle, self.scale, self.scale, self.originX, self.originY)
        end

        if self.highlighted or (HOVERED_TILE and HOVERED_TILE.building == self) then
            if self.highlighted then
                OUTLINE_SHADER:send("opacity", 0.7)
            else
                OUTLINE_SHADER:send("opacity", 0.3)
            end

            love.graphics.setShader(OUTLINE_SHADER)
            love.graphics.draw(STORAGE_ROOF_IMAGE, self.x, self.y, self.angle, self.scale, self.scale, self.originX, self.originY)
            love.graphics.setShader()
        end
    end

    building.updateStorage = function(self)
        local usedStorage = 0
        local totalResources = 2

        MAX_WOOD = MAX_WOOD + round(self.totalStorage / totalResources)
        usedStorage = usedStorage + self.totalStorage / totalResources

        MAX_FOOD = MAX_FOOD + self.totalStorage - usedStorage
    end

    building:updateStorage()
    building:setGrid()

    return building
end