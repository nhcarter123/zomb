return {
    create = function(gridX, gridY)
        local building = Building.create(gridX, gridY, 0, 0, WOOD_WALL_1_IMAGE)

        building.title = "Wood wall"
        building.description =  "Cheap protection that stops enemies in their tracks"
        building.isWall = true
        building.scale = 0.54
        building.health = 100
        building.maxHealth = 100
        building.cost = {{ "Wood", 2 } }
        building.material = "Wood"

        building.setImage = function(self)
            local canvas = love.graphics.newCanvas(256)
            local hash = ""

            for j = -1, 1 do
                for i = -1, 1 do
                    local neighbor = grid[self.gridX + i][self.gridY + j]
                    if (neighbor.building and (neighbor.building.isWall or neighbor.building.connectsWithWall)) or neighbor.mountain then
                        hash = hash.."1"
                    else
                        hash = hash.."0"
                    end
                end
            end

            local padding = 1
            local tileSize = 128 + padding * 2
            local cachedImage = WALL_PIECE_CACHE[self.material][hash]

            if cachedImage then
                self.image = cachedImage
            else
                local canvas = love.graphics.newCanvas(tileSize, tileSize)
                love.graphics.setCanvas(canvas)

                for i = 1, #hash do
                    local value = string.sub(hash, i, i)
                    if value == "1" then
                        if i ~= 5 then
                            local wallPiece = WOOD_WALL_2_IMAGE
                            if self.material == "Stone" then
                                wallPiece = STONE_WALL_2_IMAGE
                            end

                            if (i % 2) == 0 then
                                wallPiece = WOOD_WALL_3_IMAGE
                                if self.material == "Stone" then
                                    wallPiece = STONE_WALL_3_IMAGE
                                end
                            end

                            local angle = 270

                            if i == 3 or i == 6 then
                                angle = 0
                            elseif i == 4 or i == 7 then
                                angle = 180
                            elseif i == 8 or i == 9 then
                                angle = 90
                            end

                            love.graphics.draw(wallPiece, tileSize / 2, tileSize / 2, toRad(angle), 1, 1, tileSize / 2 - padding, tileSize / 2 - padding)
                        end
                    end
                end

                if self.material == "Stone" then
                    love.graphics.draw(STONE_WALL_1_IMAGE, padding, padding)
                else
                    love.graphics.draw(WOOD_WALL_1_IMAGE, padding, padding)
                end

                love.graphics.setCanvas()

                self.image = canvas
                WALL_PIECE_CACHE[self.material][hash] = canvas
            end

            self.originX = tileSize / 2
            self.originY = tileSize / 2
        end

        local parentInit = building.init
        building.init = function(self)
            parentInit(self)
            self:setWallImages()
        end

        return building
    end
}

