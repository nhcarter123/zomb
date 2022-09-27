function createSelected(shape, image, createFn, offsetX, offsetY, cost)
    local selected = {
        image = image,
        halfWidth = image:getWidth() / 2,
        halfHeight = image:getHeight() / 2,
        shape = shape,
        createFn = createFn,
        gridX = 0,
        gridY = 0,
        scale = 1,
        offsetX = offsetX,
        offsetY = offsetY,
        canPlace = false,
        cost = cost,

        update = function(self)
            local mx, my = love.mouse.getPosition()
            local worldMx, worldMy = cam:toWorld(mx, my)
            local gridX = toGridSpace(worldMx)
            local gridY = toGridSpace(worldMy)

            self.x = (gridX + self.offsetX) * GRID_SIZE
            self.y = (gridY + self.offsetY) * GRID_SIZE

            if gridX ~= self.gridX or gridY ~= self.gridY then
                self.canPlace = not doesOverlap(gridX, gridY, self.shape) and MONEY >= self.cost
                self.gridX = gridX
                self.gridY = gridY
            end
        end,

        click = function(self)
            if self.canPlace then
                MONEY = MONEY - self.cost
                local building = self.createFn(self.gridX, self.gridY)
                table.insert(buildings, building)
                calculateGrid()
            end
        end,

        draw = function(self)
            if self.x ~= nil then
                if not self.canPlace then
                    love.graphics.setColor(1, 0.8, 0.8, 0.5)
                end

                love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale, self.halfWidth, self.halfHeight)
                love.graphics.setColor(1, 1, 1)
            end
        end
    }

    return selected
end