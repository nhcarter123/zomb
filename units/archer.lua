function createArcher(x, y)
    local unit = createUnit(x, y, ARCHER_IMAGE)
    local searchDuration = 2

    unit.timeOffset = math.random() * 5
    unit.searchDuration = searchDuration
    unit.searchCount = math.random() * searchDuration
    unit.gun = createBow()
    unit.scale = 0.4

    unit.state = "Sentry"
    unit.task = "Defend"

    local parentUpdate = unit.update

    unit.update = function(self, dt, time)
        local shouldDelete = parentUpdate(self)
        if shouldDelete then
            return true
        end

        self:stateMachine(dt, time)
    end

    unit.getNextState = function(self, event)
        if event == "Target gone" then
            self.state = "Sentry"
            self.searchCount = self.searchDuration
        elseif event == "New target" then
            self.state = "Attack"
        end
    end

    unit.stateMachine = function(self, dt, time)
        if self.state == 'Sentry' then
            if self.building then
                local sentryAngle = angle(self.building.x, self.building.y, self.x, self.y)
                local diff = angleDiff(toDeg(self.angle), toDeg(sentryAngle))

                self.angle = self.angle - dt * diff / 120
            end

            self.angle = self.angle + math.sin(time / 3 + self.timeOffset) / 300

            if self.searchCount >= self.searchDuration then
                self.searchCount = 0

                local closest = getClosest(self.x, self.y, enemyUnits)
                if closest then
                    self.target = closest
                    self:getNextState('New target')
                end
            else
                self.searchCount = self.searchCount + dt
            end
        elseif self.state == 'Attack' then
            if self.target.health > 0 then
                local dist = dist(self.x, self.y, self.target.x, self.target.y)
                local dir = angle(self.x, self.y, self.target.x, self.target.y)
                local speed = dt * 1000 / (self.weight + self.gun.weight)
                local mx = lengthDirX(speed, dir)
                local my = lengthDirY(speed, dir)

                if dist > self.gun.maxRange then
                    self:getNextState('Target gone')
                else
                    self.angle = dir
                    self.gun:pullTrigger(dt, self.x, self.y, dir, dist, self.target)
                end
            else
                self:getNextState('Target gone')
            end
        end
    end

    return unit
end