function setWallImages(gridX, gridY)
    for i = -1, 1 do
        for j = -1, 1 do
            local building = grid[gridX + i][gridY + j].building

            if building then
                building:setImage()
            end
        end
    end
end


function createWall(gridX, gridY)
    local building = createBuilding(gridX, gridY, 0, 0, WALL_1_IMAGE)

    building.isWall = true

    building.setImage = function(self)
        local upIsWall = false
        local downIsWall = false
        local rightIsWall = false
        local leftIsWall = false
        local downRightIsWall = false

        if self.gridX - 1 >= -GRID_TILES then
            local left = grid[self.gridX - 1][self.gridY].building
            if left and left.isWall then
                leftIsWall = true
            end
        end

        if self.gridX + 1 <= GRID_TILES then
            local right = grid[self.gridX + 1][self.gridY].building
            if right and right.isWall then
                rightIsWall = true
            end
        end

        if self.gridY - 1 >= -GRID_TILES then
            local up = grid[self.gridX][self.gridY - 1].building
            if up and up.isWall then
                upIsWall = true
            end
        end

        if self.gridY + 1 <= GRID_TILES then
            local down = grid[self.gridX][self.gridY + 1].building
            if down and down.isWall then
                downIsWall = true
            end

            if self.gridX + 1 <= GRID_TILES then
                local downRight = grid[self.gridX + 1][self.gridY + 1].building
                if downRight and downRight.isWall then
                    downRightIsWall = true
                end
            end
        end

        if upIsWall and downIsWall and rightIsWall and leftIsWall then
            self.image = WALL_9_IMAGE
            self.angle = toRad(0)
        elseif upIsWall and downIsWall and rightIsWall then
            self.image = WALL_11_IMAGE
            self.angle = toRad(180)
        elseif upIsWall and downIsWall and leftIsWall then
            self.image = WALL_11_IMAGE
            self.angle = toRad(0)
        elseif leftIsWall and downIsWall and rightIsWall then
            self.image = WALL_11_IMAGE
            self.angle = toRad(270)
        elseif leftIsWall and upIsWall and rightIsWall then
            self.image = WALL_11_IMAGE
            self.angle = toRad(90)
        elseif rightIsWall and downIsWall then
            self.image = WALL_12_IMAGE
            self.angle = toRad(0)
        elseif leftIsWall and downIsWall then
            self.image = WALL_12_IMAGE
            self.angle = toRad(90)
        elseif rightIsWall and upIsWall then
            self.image = WALL_12_IMAGE
            self.angle = toRad(270)
        elseif leftIsWall and upIsWall then
            self.image = WALL_12_IMAGE
            self.angle = toRad(180)
        elseif upIsWall and downIsWall then
            self.image = WALL_10_IMAGE
            self.angle = toRad(0)
        elseif leftIsWall and rightIsWall then
            self.image = WALL_10_IMAGE
            self.angle = toRad(90)
        elseif upIsWall then
            self.image = WALL_2_IMAGE
            self.angle = toRad(180)
        elseif downIsWall then
            self.image = WALL_2_IMAGE
            self.angle = toRad(0)
        elseif leftIsWall then
            self.image = WALL_2_IMAGE
            self.angle = toRad(90)
        elseif rightIsWall then
            self.image = WALL_2_IMAGE
            self.angle = toRad(270)
        end
    end

    building:setGrid()
    setWallImages(gridX, gridY)

    return building
end