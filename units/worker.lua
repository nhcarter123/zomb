function createWorker(x, y, type)
    local unit = createUnit(x, y, type)
    local searchDuration = 2

    unit.timeOffset = math.random() * 5
    unit.searchDuration = searchDuration
    unit.searchCount = math.random() * searchDuration
    unit.tileOffsetX = (math.random() - 0.5) * GRID_SIZE * 0.7
    unit.tileOffsetY = (math.random() - 0.5) * GRID_SIZE * 0.7

    unit.state = "Traveling"
    unit.task = "Cut wood"

    unit.update = function(self, dt, time)
        if self.health <= 0 then
            return true -- flag for deletion
        end

        if self.searchCount >= self.searchDuration then
            self.searchCount = 0

            local closest = getClosest(self.x, self.y, enemyUnits)
            if closest then
                self.target = closest
                self.state = 'attack'
            end
        else
            self.searchCount = self.searchCount + dt
        end

        if self.type == E_UNIT_FARMER then
            self:farmerStateMachine(dt, time)
        elseif self.type == E_UNIT_SOLDIER then
            self:soldierStateMachine(dt, time)
        end
    end

    unit.draw = function(self)
        love.graphics.draw(self.image, self.x, self.y, self.angle, 0.5, 0.5, self.originX, self.originY)
        self.drawHealthbar(self)
    end

    unit.getNextState = function(self, event)
        if event == "Arrival" then
            if self.task == "Cut wood" then
                if self.state == "Traveling" then
                    self.state = "Chop wood"
                    self.target.beingCut = true
                end
            end
        end
    end

    unit.farmerStateMachine = function(self, dt, time)
        if self.targetGridX ~= nil then
            local targetX = toWorldSpace(self.targetGridX) + self.tileOffsetX
            local targetY = toWorldSpace(self.targetGridY) + self.tileOffsetY

            local dist = dist(self.x, self.y, targetX, targetY)

            if dist > 10 then
                local dir = angle(self.x, self.y, targetX, targetY)
                local speed = dt * 250 / self.weight
                local mx = lengthDirX(speed, dir)
                local my = lengthDirY(speed, dir)


                local diff = angleDiff(toDeg(self.angle), toDeg(dir))
                self.angle = self.angle - dt * diff / 10

                self.x = self.x + mx
                self.y = self.y + my
            else
                self.targetGridX = nil
                self.targetGridY = nil
                self:getNextState("Arrival")
            end
        end

        if self.task == "Cut wood" then
            if not self.target then
                local closest = getClosest(self.x, self.y, buildings, 0, isTree)
                if closest then
                    self.target = closest
                    self.targetGridX = closest.gridX
                    self.targetGridY = closest.gridY
                end
            end

            if self.state == "Chop wood" then
                local dir = angle(self.x, self.y, self.target.x, self.target.y)
                local diff = angleDiff(toDeg(self.angle), toDeg(dir))
                self.angle = self.angle - dt * diff / 10
            end
        end
    end

    unit.soldierStateMachine = function(self, dt, time)
        if self.state == 'sentry' then
            if self.building then
                local sentryAngle = angle(self.building.x, self.building.y, self.x, self.y)
                local diff = angleDiff(toDeg(self.angle), toDeg(sentryAngle))

                self.angle = self.angle - dt * diff / 200
            end

            self.angle = self.angle + math.sin(time / 3 + self.timeOffset) / 300
        elseif self.state == 'attack' then
            if self.target.health > 0 then
                local dist = dist(self.x, self.y, self.target.x, self.target.y)
                local dir = angle(self.x, self.y, self.target.x, self.target.y)
                local speed = dt * 1000 / (self.weight + self.gun.weight)
                local mx = lengthDirX(speed, dir)
                local my = lengthDirY(speed, dir)

                if dist > self.gun.maxRange then
                    --                        -- walk to target
                    --                        self.x = self.x + mx
                    --                        self.y = self.y + my
                    --                        self.angle = dir + toRad(90)
                else
                    self.angle = dir
                    self.gun:pullTrigger(dt, self.x, self.y, dir + toRad(90), dist, self.target)
                end
            else
                self.state = 'sentry'
                self.searchCount = self.searchDuration
            end
        end
    end

    return unit
end

function isTree(building)
    return building.isTree
end