function createBuilding(gridX, gridY, offsetX, offsetY, image)
    return {
        x = (gridX + offsetX) * GRID_SIZE,
        y = (gridY + offsetY) * GRID_SIZE,
        gridX = gridX,
        gridY = gridY,
        image = image,
        health = 50,
        maxHealth = 50,
        originX = image:getWidth() / 2,
        originY = image:getHeight() / 2,
        imageHeight = image:getHeight(),
        shape = {{1}},

        update = function(self)
            if self.health <= 0 then
                self:setGrid(true)

                return true -- flag for deletion
            end
        end,

        setGrid = function(self, setNil)
            GRID_DIRTY = true

            local value = self
            if setNil then
                value = nil
            end

            for j = 0, #self.shape - 1 do
                local row = self.shape[j + 1]
                for i = 0, #row - 1 do
                    grid[self.gridX + i][self.gridY + j].building = value
                end
            end
        end,

        draw = function(self)
            love.graphics.draw(self.image, self.x, self.y, self.angle, self.scale, self.scale, self.originX, self.originY)

            if self.highlighted or (HOVERED_TILE and HOVERED_TILE.building == self) then
                if self.highlighted then
                    OUTLINE_SHADER:send("opacity", 0.7)
                else
                    OUTLINE_SHADER:send("opacity", 0.3)
                end

                love.graphics.setShader(OUTLINE_SHADER)
                love.graphics.draw(self.image, self.x, self.y, self.angle, self.scale, self.scale, self.originX, self.originY)
                love.graphics.setShader()
            end
        end,

        getStats = function(self)
            return nil
        end,

--        getOpenNeighborTilePos = function(self)
--            for j = 0, #self.shape - 1 do
--                local row = self.shape[j + 1]
--                for i = 0, #row - 1 do
--                    for k = -1, 1 do
--                        for l = -1, 1 do
--                            if not (k == 0 and l == 0) then
--                                local x = self.gridX + i + k
--                                local y = self.gridY + j + l
--                                if x >= -GRID_TILES and x <= GRID_TILES and
--                                   y >= -GRID_TILES and y <= GRID_TILES
--                                then
--                                    local occupied = grid[x][y].building
--                                    if not occupied then
--                                        return x, y
--                                    end
--                                end
--                            end
--                        end
--                    end
--                end
--            end
--        end,

        drawHealthbar = function(self)
            if self.health < self.maxHealth then
                local healthBarWidth = 40
                local healthBarHeight = 8
                local offsetY = 20
                local percentHealth = self.health / self.maxHealth
                love.graphics.setColor(0.2, 0.2, 0.2)
                love.graphics.rectangle("fill", self.x - healthBarWidth / 2, self.y + offsetY, healthBarWidth, healthBarHeight)
                love.graphics.setColor(0.2, 0.9, 0.2)
                love.graphics.rectangle("fill", self.x - healthBarWidth / 2 + 1, self.y + offsetY - 1, healthBarWidth * percentHealth - 2, healthBarHeight - 2)
                love.graphics.setColor(1, 1, 1)
            end
        end,

        setWallImages = function(self, gridX, gridY)
            for i = -1, 1 do
                for j = -1, 1 do
                    local building = grid[gridX + i][gridY + j].building

                    if building and building.isWall then
                        building:setImage()
                    end
                end
            end
        end,
    }
end