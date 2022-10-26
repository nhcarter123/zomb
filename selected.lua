return {
    create = function(createFn, cost)
        local obj = createFn(0, 0)

        return {
            obj = obj,
            halfWidth = obj.image:getWidth() / 2,
            halfHeight = obj.image:getHeight() / 2,
            cost = cost,
            createFn = createFn,

            canAfford = function(self)
                local canAfford = true
                for i = 1, #self.cost do
                    local type = self.cost[i][1]
                    if type == "Wood" then
                        if WOOD < self.cost[i][2] then
                            canAfford = false
                        end
                    elseif type == "Food" then
                        if FOOD < self.cost[i][2] then
                            canAfford = false
                        end
                    elseif type == "Stone" then
                        if STONE < self.cost[i][2] then
                            canAfford = false
                        end
                    end
                end

                return canAfford
            end,

            update = function(self)
                local mx, my = love.mouse.getPosition()
                local worldMx, worldMy = cam:toWorld(mx, my)
                local gridX = toGridSpace(worldMx + GRID_SIZE * self.obj.offsetX)
                local gridY = toGridSpace(worldMy + GRID_SIZE * self.obj.offsetY)

                if gridX ~= self.gridX or gridY ~= self.gridY or not self.visible then
                    self.visible = true
                    self.canPlace = not doesOverlap(gridX - self.obj.offsetX * 2, gridY - self.obj.offsetY * 2, self.obj.shape) and self:canAfford()

                    if self.canPlace then
                        self.obj.x = (gridX - self.obj.offsetX) * GRID_SIZE
                        self.obj.y = (gridY - self.obj.offsetY) * GRID_SIZE
                    else
                        self.obj.x = worldMx
                        self.obj.y = worldMy
                    end

                    self.obj.gridX = gridX - self.obj.offsetX * 2
                    self.obj.gridY = gridY - self.obj.offsetY * 2
                    if self.obj.getAOE then
                        self.obj:getAOE()
                    end
                end
            end,

            click = function(self)
                if self.canPlace then
                    for i = 1, #self.cost do
                        local type = self.cost[i][1]
                        if type == "Wood" then
                            WOOD = WOOD - self.cost[i][2]
                        elseif type == "Food" then
                            FOOD = FOOD - self.cost[i][2]
                        elseif type == "Stone" then
                            STONE = STONE - self.cost[i][2]
                        end
                    end

                    updateStorage()
                    table.insert(buildings, self.obj)
                    self.visible = false
                    self.obj:init()
                    self.obj = self.createFn(0, 0)
                    self.canPlace = not doesOverlap(self.obj.gridX, self.obj.gridY, self.obj.shape) and self:canAfford()
                end
            end,

            draw = function(self)
                if self.visible then
                    if not self.canPlace then
                        love.graphics.setColor(1, 0.7, 0.7, 0.6)
                    else
                        love.graphics.setColor(1, 1, 1, 0.6)
                    end

                    love.graphics.draw(self.obj.image, self.obj.x, self.obj.y, 0, self.obj.scale, self.obj.scale, self.halfWidth, self.halfHeight)

                    if self.obj.getAOE and self.canPlace then
                        self.obj:drawAOE()
                    end

                    love.graphics.setColor(1, 1, 1)
                end
            end
        }
    end
}