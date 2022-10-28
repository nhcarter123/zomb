calculateResourceValue = function(type, amount)
    if type == "Food" then
        return amount * FOOD_VALUE
    end

    if type == "Wood" then
        return amount * WOOD_VALUE
    end

    if type == "Stone" then
        return amount * STONE_VALUE
    end
end

return {
    spawnCount = 0,
    spawnDuration = 15000000000,
    enemiesToSpawn = {},

    update = function(self, dt)
        self.spawnCount = self.spawnCount + dt

        if self.spawnCount > self.spawnDuration then
            self.spawnCount = 0
            self:spawn(0.01)
        end

        for i = #self.enemiesToSpawn, 1, -1 do
            local enemy = self.enemiesToSpawn[i]

            if enemy.delay > 0 then
                enemy.delay = enemy.delay - dt
            else
                table.insert(enemyUnits, enemy)
                table.remove(self.enemiesToSpawn, i)
            end
        end
    end,

    spawn = function(self, mod)
        local mod = 1 + math.random() / 4
        local buildingScore = self:calculateBuildingWealth() / 50
        local resourceScore = self:calculateResourceWealth()/ 50
        local popScore = POPULATION
        local dayScore = math.pow(2 * (TimeManager.day * 24 + TimeManager.time), 1.05)
        local strength = buildingScore + resourceScore + popScore + dayScore

--        love.window.showMessageBox("test", tostring(buildingScore))
--        love.window.showMessageBox("test", tostring(resourceScore))
--        love.window.showMessageBox("test", tostring(popScore))
--        love.window.showMessageBox("test", tostring(dayScore))

        local enemyPoints = round(mod * (strength / 4))
        local groupCount = math.ceil(math.random() * 8)
        local zombieValue = 4
        local ogreValue = 16

        self.enemiesToSpawn = {}
        local lowestDelay = 999

        for i = 1, groupCount do
            local groupPoints = math.ceil(strength / groupCount) -- this can be improved
            local groupX, groupY

            if math.random() > 0.5 then
                groupX = (GRID_TILES + 3) * GRID_SIZE
                groupY = 2 * GRID_TILES * GRID_SIZE * (math.random() - 0.5)

                if math.random() > 0.5 then
                    groupX = -groupX
                end
            else
                groupX = 2 * GRID_TILES * GRID_SIZE * (math.random() - 0.5)
                groupY = (GRID_TILES + 3) * GRID_SIZE

                if math.random() > 0.5 then
                    groupY = -groupY
                end
            end

            local dir = angle(groupX, groupY, 0, 0)
            local distance = dist(groupX, groupY, 0, 0)

            local points = 0
            while points < groupPoints do
                local x = groupX + (math.random() - 0.5) * GRID_SIZE * 3
                local y = groupY + (math.random() - 0.5) * GRID_SIZE * 3
                local rand = math.random()
                local enemy

                if rand > 0.75 and (groupPoints - points) > ogreValue then
                    points = points + ogreValue
                    enemy = Ogre.create(x, y)
                else
                    points = points + zombieValue
                    enemy = createZombie(x, y)
                end

                enemy.delay = distance * (1 + math.random() * 0.25) * enemy.timeScale / 1000

                if enemy.delay < lowestDelay then
                    lowestDelay = enemy.delay
                end

                table.insert(self.enemiesToSpawn, enemy)
            end
        end

        for i = #self.enemiesToSpawn, 1, -1 do
            local enemy = self.enemiesToSpawn[i]
            enemy.delay = enemy.delay - lowestDelay
        end

        TimeManager.timeScale = 1
    end,

    calculateBuildingWealth = function()
        local wealth = 0

        for i = 1, #buildings do
            local building = buildings[i]
            if building.cost then
                for j = 1, #building.cost do
                    wealth = wealth + calculateResourceValue(building.cost[j][1], building.cost[j][2])
                end
            end
        end

        return wealth
    end,

    calculateResourceWealth = function()
        local wealth = 0

        return wealth +
            calculateResourceValue("Food", FOOD) +
            calculateResourceValue("Wood", WOOD) +
            calculateResourceValue("Stone", STONE)
    end,
}