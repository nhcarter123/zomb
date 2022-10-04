function createSelected(shape, image, selectedObject, offsetX, offsetY, cost)
    local canAfford = true
    for i = 1, #cost do
        local type = cost[i][1]
        if type == "Wood" then
            if WOOD < cost[i][2] then
                canAfford = false
            end
        elseif type == "Food" then
            if FOOD < cost[i][2] then
                canAfford = false
            end
        end
    end

    local selected = {
        image = image,
        halfWidth = image:getWidth() / 2,
        halfHeight = image:getHeight() / 2,
        shape = shape,
        selectedObject = selectedObject,
        gridX = 0,
        gridY = 0,
        scale = 1,
        offsetX = offsetX,
        offsetY = offsetY,
        canPlace = false,
        canAfford = canAfford,
        cost = cost,

        update = function(self)
            local mx, my = love.mouse.getPosition()
            local worldMx, worldMy = cam:toWorld(mx, my)
            local gridX = toGridSpace(worldMx)
            local gridY = toGridSpace(worldMy)

            self.x = (gridX + self.offsetX) * GRID_SIZE
            self.y = (gridY + self.offsetY) * GRID_SIZE

            if gridX ~= self.gridX or gridY ~= self.gridY then
                self.canPlace = not doesOverlap(gridX, gridY, self.shape) and self.canAfford
                self.gridX = gridX
                self.gridY = gridY
                if self.selectedObject.getAOE then
                    self.aoe = self.selectedObject.getAOE(gridX, gridY)
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
                    end
                end

                local building = self.selectedObject:create(self.gridX, self.gridY)
                table.insert(buildings, building)
                self.aoe = building.aoe
            end
        end,

        draw = function(self)
            if self.x ~= nil then
                if not self.canPlace then
                    love.graphics.setColor(1, 0.8, 0.8, 0.5)
                end

                love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale, self.halfWidth, self.halfHeight)

                if self.aoe then
                    drawAOE(self.aoe, self.x, self.y)
                end

                love.graphics.setColor(1, 1, 1)
            end
        end
    }

    return selected
end