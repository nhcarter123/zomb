function getWallTitle()
   return "Wood wall"
end

function getWallDescription()
   return "Cheap protection that stops zombies in their tracks"
end

function createWall(gridX, gridY)
    local building = createBuilding(gridX, gridY, 0, 0, WALL_PIECE_1_IMAGE)

    building.isWall = true
    building.scale = 0.52
    building.title = getWallTitle()
    building.description = getWallDescription()
    building.health = 150
    building.maxHealth = 150

    local parentUpdate = building.update
    building.update = function(self)
        if parentUpdate(self) then
            self:setWallImages(self.gridX, self.gridY)
            return true
        end
    end

    building.setImage = function(self)
        local canvas = love.graphics.newCanvas(256)
        local hash = ""

        for j = -1, 1 do
            for i = -1, 1 do
                local neighbor = grid[self.gridX + i][self.gridY + j].building
                if neighbor and (neighbor.isWall or neighbor.connectsWithWall) then
                    hash = hash.."1"
                else
                    hash = hash.."0"
                end
            end
        end

        local cachedImage = WALL_PIECE_CACHE[hash]

        if cachedImage then
            self.image = cachedImage
        else
            local tileSize = 128
            local canvas = love.graphics.newCanvas(tileSize, tileSize)
            love.graphics.setCanvas(canvas)

            for i = 1, #hash do
                local value = string.sub(hash, i, i)
                if value == "1" then
                    if i ~= 5 then
                        local wallPiece = WALL_PIECE_2_IMAGE
                        if (i % 2) == 0 then
                            wallPiece = WALL_PIECE_3_IMAGE
                        end

                        local angle = 270

                        if i == 3 or i == 6 then
                            angle = 0
                        elseif i == 4 or i == 7 then
                            angle = 180
                        elseif i == 8 or i == 9 then
                            angle = 90
                        end

                        love.graphics.draw(wallPiece, tileSize / 2, tileSize / 2, toRad(angle), 1, 1, tileSize / 2, tileSize / 2)
                    end
                end
            end

            love.graphics.draw(WALL_PIECE_1_IMAGE, 0, 0)

            love.graphics.setCanvas()

            self.image = canvas
            WALL_PIECE_CACHE[hash] = canvas
        end
    end

    building:setGrid()
    building:setWallImages(gridX, gridY)

    return building
end