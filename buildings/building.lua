updateStorage = function()
    local anySpaceAvailable = false
    local wood = WOOD
    local woodSpaceAvailable = false
    local food = FOOD
    local foodSpaceAvailable = false
    local stone = STONE
    local stoneSpaceAvailable = false

    for i = 1, #buildings do
        local building = buildings[i]

        if building.storageCapactiy then
            for j = 1, building.storageCapactiy do
                local storage = building.storage[j]
                local type
                local savedAmount = 0
                local storageSet = false
                if storage then
                    type = storage.type
                    savedAmount = storage.amount
                end

                if (not type or type == "Wood") then
                    local delta = math.min(wood, WOOD_MAX_STACK_SIZE)

                    if delta > 0 then
                        local image = LUMBER_IMAGE_1

                        if wood > WOOD_MAX_STACK_SIZE * 0.25 then
                            image = LUMBER_IMAGE_2
                        end

                        if wood > WOOD_MAX_STACK_SIZE * 0.75 then
                            image = LUMBER_IMAGE_3
                        end

                        wood = wood - delta

                        storage = {
                            image = image,
                            amount = delta,
                            type = "Wood"
                        }
                        storageSet = true
                    else
                        if savedAmount > wood then
                            type = nil
                            storage = nil
                        end

                        woodSpaceAvailable = true
                    end
                end

                if (not type or type == "Food") and not storageSet then
                    local delta = math.min(food, FOOD_MAX_STACK_SIZE)

                    if delta > 0 then
                        local image = BREAD_IMAGE_1

                        if food > FOOD_MAX_STACK_SIZE * 0.25 then
                            image = BREAD_IMAGE_2
                        end

                        if food > FOOD_MAX_STACK_SIZE * 0.75 then
                            image = BREAD_IMAGE_3
                        end

                        food = food - delta

                        storage = {
                            image = image,
                            amount = delta,
                            type = "Food"
                        }
                        storageSet = true
                    else
                        if savedAmount > food then
                            type = nil
                            storage = nil
                        end

                        foodSpaceAvailable = true
                    end
                end

                if (not type or type == "Stone") and not storageSet then
                    local delta = math.min(stone, STONE_MAX_STACK_SIZE)

                    if delta > 0 then
                        local image = STONE_IMAGE_1

                        if stone > STONE_MAX_STACK_SIZE * 0.25 then
                            image = STONE_IMAGE_2
                        end

                        if stone > STONE_MAX_STACK_SIZE * 0.75 then
                            image = STONE_IMAGE_3
                        end

                        stone = stone - delta

                        storage = {
                            image = image,
                            amount = delta,
                            type = "Stone",
                        }
                        storageSet = true
                    else
                        if savedAmount > food then
                            type = nil
                            storage = nil
                        end

                        stoneSpaceAvailable = true
                    end
                end

                if not storage then
                    anySpaceAvailable = true
                end

                building.storage[j] = storage
            end
        end
    end

    WOOD_SPACE_AVAILABLE = anySpaceAvailable or woodSpaceAvailable
    FOOD_SPACE_AVAILABLE = anySpaceAvailable or foodSpaceAvailable
    STONE_SPACE_AVAILABLE = anySpaceAvailable or stoneSpaceAvailable
end

setWorkers = function()
    local workerCount = POPULATION
    local residentCount = POPULATION

    local workerBuildings = {}

    for i = 1, #buildings do
        local building = buildings[i]
        if building.needsWorker and not building.forbid then
            table.insert(workerBuildings, building)
        end

    -- Todo maybe move this
        if building.isTotem then
            building:getAOE()
        end
    end

    table.sort(workerBuildings, workerSort)

    for i = 1, #workerBuildings do
        local building = workerBuildings[i]
        if building.needsWorker and not building.forbid then
            if workerCount > 0 then
                workerCount = workerCount - 1
                building.hasWorker = true
            else
                building.hasWorker = false
            end
        end
    end
end

getGridCircle = function(gridX, gridY, r, validFn, offsetX, offsetY)
    local tiles = {}
    local targets = {}

    for i = -r, r + 1 do
        for j = -r, r + 1 do
            local distance = dist(offsetX, offsetY, i, j)
            if distance <= r then
                local x = gridX + i
                local y = gridY + j
                if x >= -GRID_TILES and x <= GRID_TILES and y >= -GRID_TILES and y <= GRID_TILES then
                    if grid[x] and validFn and validFn(grid[x][y]) then
                        local potentialTarget = grid[x][y].building

                        if not contains(targets, potentialTarget) then
                            table.insert(targets, potentialTarget)
                        end
                    end
                end

                table.insert(tiles, { i, j })
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
            height = 1,
            affectedBy = {},

            title = "Wood wall",
            description = "Cheap protection that stops enemies in their tracks",

            update = function(self)
                if self.health <= 0 then
                    self:setGrid(true)

                    if self.needsWorker then
                        setWorkers()
                    end

                    if self.isWall or self.connectsWithWall then
                        self:setWallImages()
                    end

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
                if self.height > 0 then
                    local slope = self.originY / self.originX
                    local scaleX = 1 + self.height * 150 / self.originX--self.scale * self.originX / GRID_SIZE-- + 6 / self.originX
                    local scaleY = 1 + self.height * 150 / self.originY--self.scale * self.originY / GRID_SIZE-- + 6 / self.originY
                    DropShadowShader:send("size", { scaleX, scaleY, self.height / (self.scale * self.originX / GRID_SIZE), slope } )
                    love.graphics.draw(self.image, self.x, self.y, self.angle, scaleX * self.scale, scaleY * self.scale, self.originX, self.originY)
                end
            end,

            draw = function(self, isFloor)
--                love.graphics.setColor(0, 0, 0, 0.3)
--                love.graphics.draw(self.image, self.x + 20, self.y + 20, self.angle, self.scale, self.scale, self.originX, self.originY)
--                love.graphics.setColor(1, 1, 1, 1)
                if (isFloor and self.height == 0) or (not isFloor and self.height > 0) then
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
                    love.graphics.draw(REMOVE_ICON_IMAGE, self.x, self.y, self.angle, 0.25, 0.25, ICON_ORIGIN_X, ICON_ORIGIN_Y)
                elseif not self.hasWorker and self.needsWorker and self.initialized then
                    love.graphics.draw(WARNING_ICON_IMAGE, self.x, self.y, self.angle, 0.25, 0.25, ICON_ORIGIN_X, ICON_ORIGIN_Y)
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

                    love.graphics.setColor(1, 1, 1, 0.1)

                    love.graphics.rectangle("fill", self.x + (tile[1] - 0.5 - self.offsetX) * GRID_SIZE + 2, self.y + (tile[2] - 0.5 - self.offsetY) * GRID_SIZE + 2, GRID_SIZE - 4, GRID_SIZE - 4)
                end


                love.graphics.setColor(1, 1, 1)

                if self.targets and self.targets[1] then
                    love.graphics.setShader(LineShader)

                    for i = 1, #self.targets do
                        local target = self.targets[i]
                        local dir = angle(self.x, self.y, target.x, target.y)
                        local dist = dist(self.x, self.y, target.x, target.y)

                        LineShader:send("time", -time)
                        LineShader:send("scale", dist)
                        love.graphics.draw(SHADOW_IMAGE, self.x, self.y, dir - toRad(90), 3, dist)
                    end

                    love.graphics.setShader()
                end
            end,

            init = function(self)
                self:setGrid()

                if self.needsWorker or self.isHouse then
                    setWorkers()
                end

                self.initialized = true
            end
        }
    end
}