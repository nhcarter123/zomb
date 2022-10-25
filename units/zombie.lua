function createZombie(x, y)
    local unit = createUnit(x, y, ZOMBIE_IMAGE)

--    unit.animation = createAnimation(image, 72, 78, 1)
    unit.spread = GRID_SIZE * (math.random() - 0.5)
    unit.attackCount = 0
    unit.attackCooldownDuration = 1
    unit.attackDuration = unit.attackCooldownDuration + 1
    unit.attacking = false
    unit.attackOffsetX = 0
    unit.attackOffsetY = 0
    unit.healthBarR = 0.9
    unit.healthBarG = 0.2
    unit.healthBarB = 0.2
    unit.debugX = 0
    unit.debugY = 0
    unit.path = 1
    unit.targetX = 0
    unit.targetY = 0
--    unit.speedMod = 1 + math.random() / 3
    unit.timeScale = 1
    unit.size = 1
    unit.damage = 4
    unit.turnVel = 0

    unit.update = function(self, dt, index)
        dt = dt * 12 * self.timeScale
        if self.health <= 0 then
            grid[self.gridX][self.gridY].units = grid[self.gridX][self.gridY].units - 1
            return true -- flag for deletion
        end

        local gridX = toGridSpace(self.x)
        local gridY = toGridSpace(self.y)
        local tile = grid[gridX][gridY]

        if gridX ~= self.gridX or gridY ~= self.gridY then
            local threshold = 15 / ((tile.flow[self.path].nextTile.units + tile.units + 5) * self.size)
            local rand = (math.random() - 0.5)

            if math.random() > threshold and self.cachedTile then
                local randX = math.floor(math.random() * 3) - 1
                local randY = math.floor(math.random() * 3) - 1

                if randX ~= 0 and randY ~= 0 then
--                    self.cachedTile = grid[toGridSpace(self.cachedTile.x + randX)][toGridSpace(self.cachedTile.y) + randY]
--                    grid[gridX + randX][gridY + randY]

                    local upRight = randX == 1 and randY == -1
                    local downRight = randX == 1 and randY == 1
                    local upLeft = randX == -1 and randY == -1
                    local downLeft = randX == -1 and randY == 1

                    if not tile.building then
                        local left = grid[toGridSpace(self.cachedTile.x - 1)][toGridSpace(self.cachedTile.y)].building
                        local up = grid[toGridSpace(self.cachedTile.x - 1)][toGridSpace(self.cachedTile.y)].building
                        local right = grid[toGridSpace(self.cachedTile.x - 1)][toGridSpace(self.cachedTile.y)].building
                        local down = grid[toGridSpace(self.cachedTile.x - 1)][toGridSpace(self.cachedTile.y)].building

                        if
                            (upRight and not (up and right)) or
                            (downRight and not (down and right)) or
                            (upLeft and not (up and left)) or
                            (downLeft and not (down and left))
                        then
    --                        local nextTile = grid[toGridSpace(self.cachedTile.x + randX)][toGridSpace(self.cachedTile.y + randY)]
                            self.cachedTile = grid[toGridSpace(self.cachedTile.x + randX)][toGridSpace(self.cachedTile.y + randY)]
                        end
                    end
                end
            end

            self.path = 1
--            if math.random() > threshold then
--                if rand > 0 then
--                    self.path = 2
--                end
--                if rand > 0.25 then
--                    self.path = 3
--                end
--            end


--            if not tile.tight and math.random() > threshold  then
----                   self.spread = 300 * rand
--                spreadFactor = 120
--            end

--            self.spread = (self.spread + spreadFactor * rand) / 1.1

--            if not tile.tight then
--                self.spread = clamp(-GRID_SIZE, self.spread, GRID_SIZE)
--            else
--                self.spread = clamp(-GRID_SIZE / 8, self.spread, GRID_SIZE / 8)
--            end
            if self.gridX and self.gridY then
                local previousTile = grid[self.gridX][self.gridY]
                previousTile.units = previousTile.units - 1
                tile.units = tile.units + 1
            else
                tile.units = tile.units + 1
            end

            self.attacking = false

            if self.cachedTile == tile or not self.cachedTile then
                if not tile.building then
                    self.previousCachedTile = self.cachedTile
                end
                self.cachedTile = tile.flow[self.path].nextTile
                self.attacking = true
            end

            self.gridX = gridX
            self.gridY = gridY
        end

--        local flowDir = angle(gridX, gridY, tile.flow.x, tile.flow.y)
--        local side = 1
--        if math.abs(tile.flow.x) > 0 and math.abs(tile.flow.y) > 0 then
--            side = 2 * (tile.weight % 2) - 1
--        end
--
--
--        local dir = angle(self.x, self.y, tile.flow.targetX + lengthDirX(side * self.spread, flowDir + toRad(90)), tile.flow.targetY + lengthDirY(side * self.spread, flowDir + toRad(90)))
        local flowDir = 0
        local dir = 0
        local targetSpeed = 0
        local speed = 0

        if (tile.building and not tile.building.isStone and not tile.building.isTree) and self.attacking then
            -- If the grid has updated and the last tile was actially better then stop attacking and go back
            if self.previousCachedTile and self.previousCachedTile.weight < tile.weight then
                self.attacking = false
                self.cachedTile = self.previousCachedTile
            end

            self.targetX = lerp(self.targetX, gridX * GRID_SIZE, 0.1)
            self.targetY = lerp(self.targetY, gridY * GRID_SIZE, 0.1)
            dir = angle(self.x, self.y, self.targetX, self.targetY)
--            self.spread = 0

            if self.attackCount > self.attackCooldownDuration then
                if self.attackCount > self.attackDuration then
                    self.attackCount = 0
                    if not tile.building then
                        self.attacking = false
                    end
                end

                local totalAttackTime = self.attackDuration - self.attackCooldownDuration
                local pct = math.max(self.attackCount - self.attackCooldownDuration, 0) / totalAttackTime
                local attackLength = 75 * pct

                if pct > 0.109 then
                    if self.hadNotHitYet and tile.building then
                        tile.building.health = tile.building.health - self.damage
                        self.hadNotHitYet = false
                    end
                    attackLength = 1 / pct - totalAttackTime
                else
                    self.hadNotHitYet = true
                end

                self.attackOffsetX = lengthDirX(attackLength, dir)
                self.attackOffsetY = lengthDirY(attackLength, dir)
            end

            self.attackCount = self.attackCount + dt
        else
            self.attackCount = 0
--            self.targetX = lerp(self.targetX, tile.flow[self.path].nextTile.x + lengthDirX(self.spread, tile.flow[self.path].dir + toRad(90)), 0.02)
--            self.targetY = lerp(self.targetY, tile.flow[self.path].nextTile.y + lengthDirY(self.spread, tile.flow[self.path].dir + toRad(90)), 0.02)

            local spreadFactor = 1
--            if tile.tight then
--                spreadFactor = 0.25
--            end

            self.targetX = self.cachedTile.x + lengthDirX(spreadFactor * self.spread, tile.flow[self.path].dir + toRad(90))
            self.targetY = self.cachedTile.y + lengthDirY(spreadFactor * self.spread, tile.flow[self.path].dir + toRad(90))
            dir = angle(self.x, self.y, self.targetX, self.targetY)
            targetSpeed = 1 / (tile.flow[self.path].nextTile.units + tile.units / 2 + 35)
--            targetSpeed = self.speedMod * dt * 2000
        end

        speed = lerp(speed, targetSpeed, 0.04)

--        local speed = dt * 700 / (1 * nextTile.units + 8)
--        local speed = dt * 100
--        local mx = lengthDirX(speed, dir) + lengthDirX(speed * nextTile.units / 20, dir + toRad(90))
--        local my = lengthDirY(speed, dir) + lengthDirY(speed * nextTile.units / 20, dir + toRad(90))
        local diff = angleDiff(toDeg(self.angle), toDeg(dir))

        self.turnVel = lerp(self.turnVel, diff, 0.1)

        self.angle = self.angle - dt * self.turnVel / 10
        speed = dt * 2500000 * speed / (30 + math.abs(self.turnVel))

        self.vx = lengthDirX(speed, self.angle)
        self.vy = lengthDirY(speed, self.angle)
        self.x = self.x + self.vx
        self.y = self.y + self.vy

--        self.animation.currentTime = self.animation.currentTime + dt
--        if self.animation.currentTime >= self.animation.duration then
--            self.animation.currentTime = self.animation.currentTime - self.animation.duration
--        end
    end

    unit.draw = function(self)
        love.graphics.draw(self.image, self.x + self.attackOffsetX, self.y + self.attackOffsetY, self.angle, 0.5, 0.5, self.originX, self.originY)
--        love.graphics.line(self.x, self.y, self.targetX, self.targetY)

--        love.graphics.line(self.x, self.y, self.cachedTile.x, self.cachedTile.y)
--        if self.previousCachedTile then
--            love.graphics.line(self.x, self.y, self.previousCachedTile.x, self.previousCachedTile.y)
--        end
--        if self.cachedTile then
--            love.graphics.line(self.x, self.y, self.cachedTile.x, self.cachedTile.y)
--        end
--        if GRID_DEBUG then
--            love.graphics.line(self.x, self.y, self.cachedTile.flow[self.path].nextTile.x, self.cachedTile.flow[self.path].nextTile.y)
--        end
--        local spriteNum = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.quads) + 1
--        love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], self.x, self.y, self.angle, 0.5, 0.5, self.animation.originX, self.animation.originY)
        self.drawHealthbar(self)
    end

    return unit
end