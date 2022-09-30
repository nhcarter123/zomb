function getTowerTitle()
    return "Tower"
end

function getTowerDescription()
    return "Attacks nearby zombies"
end

function createOutpost(gridX, gridY)
    local building = createBuilding(gridX, gridY, 0, 0, TOWER_IMAGE)
    local searchDuration = 2

    building.state= "Sentry"
    building.title = getTowerTitle()
    building.description = getTowerDescription()
    building.connectsWithWall = true
    building.searchDuration = searchDuration
    building.searchCount = math.random() * searchDuration
    building.gun = createBow()
    building.scale = 0.5
    building.shape = {
        {1},
    }

    local parentUpdate = building.update

    building.update = function(self, dt)
        if parentUpdate(self) then
           return true
        end

        if self.searchCount >= self.searchDuration then
            self.searchCount = 0

            local closest = getClosest(self.x, self.y, enemyUnits)
            if closest then
                self.target = closest
                self.state = 'Attack'
            end
        else
            self.searchCount = self.searchCount + dt
        end

        self:stateMachine(dt)
    end

    building.getNextState = function(self, event)
        if event == "Target gone" then
            self.state = "Sentry"
        elseif event == "New target" then
            self.state = "Attack"
        end
    end

    building.stateMachine = function(self, dt)
        if self.state == 'Sentry' then
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

                if dist > self.gun.maxRange then
                    self:getNextState('Target gone')
                else
                    self.gun:pullTrigger(dt, self.x, self.y, dir, dist, self.target)
                end
            else
                self:getNextState('Target gone')
                self.searchCount = self.searchDuration
            end
        end
    end

    building:setGrid()
    building:setWallImages(gridX, gridY)

    return building
end