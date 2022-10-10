return {
    create = function(gridX, gridY)
        local building = Building.create(gridX, gridY, 0.5, 0.5, STORAGE_FLOOR_IMAGE)

        building.title = "Storage shed"
        building.description = "Stores resources"
--        building.alpha = 0.25
        building.scale = 0.5
        building.alpha = 1
        building.height = 0
        building.storesWood = true
        building.storesFood = true
        building.storesStone = true
        building.storage = {}
        building.storageCapactiy = 9
        building.cost = {{ "Wood", 15 }}
        building.shape = {
            {1, 1},
            {1, 1},
        }

        local parentUpdate = building.update
        building.update = function(self)
            if parentUpdate(self) then
                return true
            end

            if HOVERED_TILE and HOVERED_TILE.building == self and not SELECTED then
                self.alpha = clamp(0, self.alpha - 0.025, 1)
            else
                self.alpha = clamp(0, self.alpha + 0.025, 1)
            end
        end

--        local parentDraw = building.draw
--        building.draw = function(self)
--            parentDraw(self)
--
--            for i = 1, #self.storage do
--                local storage = self.storage[i]
--                local spacing = 32
--                local x = i - 1
--                local y = math.floor(x / 3)
--                local xPos = self.x + (x - y * 3) * spacing - 32
--                local yPos = self.y + y * spacing - 32
--                love.graphics.draw(storage.image, xPos, yPos, 0, self.scale, self.scale, 32, 32)
--
--                if targetScale > 1.5 then
--                    love.graphics.print(tostring(storage.amount), xPos - 8, yPos + 4)
--                end
--            end
--        end

        building.draw = function(self)
--            if self.alpha < 1 then
                love.graphics.draw(STORAGE_FLOOR_IMAGE, self.x, self.y, self.angle, self.scale, self.scale, self.originX, self.originY)

                for i = 1, #self.storage do
                    local storage = self.storage[i]
                    local spacing = 32
                    local x = i - 1
                    local y = math.floor(x / 3)
                    local xPos = self.x + (x - y * 3) * spacing - 32
                    local yPos = self.y + y * spacing - 32
                    love.graphics.draw(storage.image, xPos, yPos, 0, self.scale, self.scale, 32, 32)

                    if targetScale > 1.5 then
                        love.graphics.print(tostring(storage.amount), xPos - 8, yPos + 4)
                    end
                end

--                love.graphics.setColor(1, 1, 1, self.alpha)
--                love.graphics.draw(STORAGE_ROOF_IMAGE, self.x, self.y, self.angle, self.scale, self.scale, self.originX, self.originY)
--                love.graphics.setColor(1, 1, 1)
--            else
--                love.graphics.draw(STORAGE_ROOF_IMAGE, self.x, self.y, self.angle, self.scale, self.scale, self.originX, self.originY)
--            end

            if self.highlighted or (HOVERED_TILE and HOVERED_TILE.building == self and not SELECTED) then
                if self.highlighted then
                    OUTLINE_SHADER:send("opacity", 0.7)
                else
                    OUTLINE_SHADER:send("opacity", 0.3)
                end

                love.graphics.setShader(OUTLINE_SHADER)
                love.graphics.draw(STORAGE_FLOOR_IMAGE, self.x, self.y, self.angle, self.scale, self.scale, self.originX, self.originY)
                love.graphics.setShader()
            end
        end


        local parentInit = building.init
        building.init = function(self)
            parentInit(self)
            updateStorage()
        end

        return building
    end
}