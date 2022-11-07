return {
    create = function(gridX, gridY)
        local building = Building.create(gridX, gridY, 0, 0, TOWER_IMAGE)
        local searchDuration = 2

        building.title = "Tower"
        building.description = "Attacks nearby enemies"
        building.state = "Sentry"
        building.placeOnMountain = true
        building.searchDuration = searchDuration
        building.searchCount = math.random() * searchDuration
        building.gun = createBow()
        building.scale = 0.5
        building.height = 2
        building.range = 10
        building.cost = {{ "Wood", 20 }}
        building.shape = {
            {1},
        }

        building.getAOE = function(self)
            local tiles, targets = getGridCircle(self.gridX, self.gridY, self.range, nil, 0, 0)
            self.aoe = tiles
        end

        local parentUpdate = building.update

        building.update = function(self, dt)
            dt = dt * 12

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

                    if dist > self.range * GRID_SIZE then
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

        local parentInit = building.init
        building.init = function(self)
            parentInit(self)
            self:setWallImages()
        end

        building:getAOE()

        return building
    end
}