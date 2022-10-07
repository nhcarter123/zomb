setWorkers = function()
    local workerCount = POPULATION
    local residentCount = POPULATION

    for i = 1, #buildings do
        local building = buildings[i]
        if building.needsWorker and not building.forbid then
            if workerCount > 0 then
                workerCount = workerCount - 1
                building.noWorker = false
            else
                building.noWorker = true
            end
        end

        if building.isHouse then
            local delta = math.min(building.residentCapacity, residentCount)
            residentCount = residentCount - delta
            building.residentCount = delta
        end
    end
end

getGridCircle = function(gridX, gridY, r, validFn)
    local radius = r
    local tiles = {}
    local targets = {}

    for i = -r, r do
        for j = -r, r do
            local distance = dist(0, 0, i, j)
            if distance <= r then
                local isValid = false
                local x = gridX + i
                local y = gridY + j
                if x >= -GRID_TILES and x <= GRID_TILES and y >= -GRID_TILES and y <= GRID_TILES then
                    if grid[x] and validFn and validFn(grid[x][y]) then
                        isValid = true
                        table.insert(targets, grid[x][y].building)
                    end
                end

                table.insert(tiles, { i, j, isValid })
            end
        end
    end

    return tiles, targets
end

return {
    create = function(gridX, gridY, offsetX, offsetY, image)
        return {
            x = (gridX + offsetX) * GRID_SIZE,
            y = (gridY + offsetY) * GRID_SIZE,
            offsetX = offsetX,
            offsetY = offsetY,
            gridX = gridX,
            gridY = gridY,
            image = image,
            health = 50,
            maxHealth = 50,
            angle = 0,
            originX = image:getWidth() / 2,
            originY = image:getHeight() / 2,
            imageHeight = image:getHeight(),
            shape = {{1}},
            barHeight = 8,
            xPadding = 6,
            forbidOriginX = REMOVE_IMAGE:getWidth() / 2,
            forbidOriginY = REMOVE_IMAGE:getHeight() / 2,
            height = 1,

            title = "Wood wall",
            description = "Cheap protection that stops enemies in their tracks",

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

            drawShadow = function(self)
                local slope = self.originY / self.originX
                local scaleX = 1 + self.height * 150 / self.originX--self.scale * self.originX / GRID_SIZE-- + 6 / self.originX
                local scaleY = 1 + self.height * 150 / self.originY--self.scale * self.originY / GRID_SIZE-- + 6 / self.originY
                DropShadowShader:send("size", { scaleX, scaleY, self.height / (self.scale * self.originX / GRID_SIZE), slope } )
--                love.graphics.draw(self.image, self.x, self.y, self.angle, self.height * slope * self.scale + 64 / self.originX, self.height * self.scale + 64 / self.originY, self.originX, self.originY)
                love.graphics.draw(self.image, self.x, self.y, self.angle, scaleX * self.scale, scaleY * self.scale, self.originX, self.originY)
            end,

            draw = function(self)
--                love.graphics.setColor(0, 0, 0, 0.3)
--                love.graphics.draw(self.image, self.x + 20, self.y + 20, self.angle, self.scale, self.scale, self.originX, self.originY)
--                love.graphics.setColor(1, 1, 1, 1)

                love.graphics.draw(self.image, self.x, self.y, self.angle, self.scale, self.scale, self.originX, self.originY)

                if self.highlighted or (HOVERED_TILE and HOVERED_TILE.building == self and not SELECTED) then
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

            postDraw = function(self)
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

                if self.forbid then
                    love.graphics.draw(REMOVE_IMAGE, self.x, self.y, self.angle, 0.1, 0.1, self.forbidOriginX, self.forbidOriginY)
                elseif self.noWorker then
                    love.graphics.rectangle("fill", self.x, self.y, 10, 10)
                end

                if self.pct then
                    love.graphics.setColor(0.2, 0.2, 0.2, 1)
                    love.graphics.rectangle("fill", self.x - self.originX / 2 + self.xPadding, self.y - self.barHeight / 2 + self.originY / 2, self.originX - self.xPadding * 2, self.barHeight)
                    love.graphics.setColor(0.7, 0.7, 0.7, 1)
                    love.graphics.rectangle(
                        "fill",
                        self.x - self.originX / 2 + 2 + self.xPadding,
                        self.y + 2 - self.barHeight / 2 + self.originY / 2,
                        self.pct * (self.originX - 4 - self.xPadding * 2),
                        self.barHeight - 4
                    )
                    love.graphics.setColor(1, 1, 1)
                end
            end,

            getStats = function(self)
                return nil
            end,

--            nextDay = function(self)
--                return nil
--            end,

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

            setWallImages = function(self)
                for i = -1, 1 do
                    for j = -1, 1 do
                        local x = self.gridX + i
                        local y = self.gridY + j
                        if x >= -GRID_TILES and x <= GRID_TILES and y >= -GRID_TILES and y <= GRID_TILES then
                            local building = grid[x][y].building

                            if building and building.isWall then
                                building:setImage()
                            end
                        end
                    end
                end
            end,

            drawAOE = function(self)
                for i = 1, #self.aoe do
                    local tile = self.aoe[i]

                    if tile[3] then
                        love.graphics.setColor(1, 1, 1, 0.42)
                    else
                        love.graphics.setColor(1, 1, 1, 0.1)
                    end

                    love.graphics.rectangle("fill", self.x + (tile[1] - 0.5) * GRID_SIZE + 2, self.y + (tile[2] - 0.5) * GRID_SIZE + 2, GRID_SIZE - 4, GRID_SIZE - 4)
                end


                love.graphics.setColor(1, 1, 1)

                if self.closestTarget then
                    love.graphics.setShader(LineShader)

                    local dir = angle(self.x, self.y, self.closestTarget.x, self.closestTarget.y)
                    local dist = dist(self.x, self.y, self.closestTarget.x, self.closestTarget.y)

                    LineShader:send("time", time)
                    LineShader:send("scale", dist)
                    love.graphics.draw(SHADOW_IMAGE, self.x, self.y, dir - toRad(90), 3, dist)
                    love.graphics.setShader()
                end
            end,

            init = function(self)
                self:setGrid()
                self.initialized = true
            end
        }
    end
}