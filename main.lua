require("units/unit")
require("units/worker")
require("units/zombie")
require("units/tanks/tank")
require("units/tanks/m1Abrams")

require("miscMath")
require("animation")
require("bullet")
require("explosion")

require("buttons/button")
require("buttons/tab")
require("buttons/houseButton")
require("buttons/outpostButton")

require("guns/gun")
require("guns/m1911")
require("guns/m1AbramsTurret")

require("ammo/tankShell")
require("ammo/45acp")

require("buildings/building")
require("buildings/wall")
require("buildings/sandbags")
require("buildings/bunker")
require("buildings/house")
require("buildings/tree")
require("buildings/storage")

require("shaders/fowShader")

require("selected")


gamera = require("gamera")

love.window.setMode(600, 600, {
    fullscreen = true,
    borderless  = true
})
--love.window.setFullscreen(true)

targetScale = 1

offsetX = 0
offsetY = 0
time = 0

debug = {}
hud = {}
TABS = {}

playerUnits = {}
enemyUnits = {}
explosions = {}
bullets = {}
buildings = {}

grid = {}
GRID_SIZE = 64
GRID_SCALE = 2
GRASS_SCALE = 1
GRASS_TILE_SIZE = 256
GRASS_PADDING_TILES = 2
GRID_TILES = 40
TOTAL_TILES = 2 * GRID_TILES + 1

updateFieldCount = 0
UPDATE_FIELD_DURATION = 0.5

WORLD_GRAVITY = 9.8 * 40
targetCamX = 0
targetCamY = 0
camX = targetCamX
camY = targetCamY
PAN_PADDING = 100
PAN_SPEED = 15000
worldWidth = 1600 * 10
worldHeight = 900 * 10
cam = gamera.new(-worldWidth / 2, -worldHeight / 2, worldWidth, worldHeight)

FOW_SHADER = nil
SHADOW_SIZE = 10000

SEARCH_NODES = {}
MAX_SEARCHES = 2000

POPULATION = 0
MONEY = 50

SELECTED = nil
SELECTED_TAB = nil

E_UNIT_SOLDIER = "Soldier"
E_UNIT_FARMER = "Farmer"
E_UNIT_ZOMBIE = "Zombie"

--     love.window.showMessageBox("test", tostring(M1_ABRAMS_BODY_IMAGE))

function love.load()
--    love.graphics.setDefaultFilter( 'nearest', 'nearest' )

--    fb = gr.newFramebuffer(love.graphics.getWidth(), love.graphics.getHeight())
--    love.graphics.setBackgroundColor(0.7, 0.5, 0.4)

    love.graphics.setBackgroundColor(46 / 255, 50 / 255, 35 / 255)
--    love.graphics.setBackgroundColor(1, 0.8, 0.7)

    SHADOW_IMAGE = love.graphics.newImage("shadow.png")
    BUNKER_IMAGE = love.graphics.newImage("bunker.png")
--    SANDBAGS_IMAGE = love.graphics.newImage("sandbags.png")
    SANDBAGS_IMAGE = love.graphics.newImage("images/storage.png")

    WALL_1_IMAGE = love.graphics.newImage("images/wall1.png")
    WALL_2_IMAGE = love.graphics.newImage("images/wall2.png")
    WALL_3_IMAGE = love.graphics.newImage("images/wall3.png")
    WALL_4_IMAGE = love.graphics.newImage("images/wall4.png")
    WALL_5_IMAGE = love.graphics.newImage("images/wall5.png")
    WALL_6_IMAGE = love.graphics.newImage("images/wall6.png")
    WALL_7_IMAGE = love.graphics.newImage("images/wall7.png")
    WALL_8_IMAGE = love.graphics.newImage("images/wall8.png")
    WALL_9_IMAGE = love.graphics.newImage("images/wall9.png")
    WALL_10_IMAGE = love.graphics.newImage("images/wall10.png")
    WALL_11_IMAGE = love.graphics.newImage("images/wall11.png")
    WALL_12_IMAGE = love.graphics.newImage("images/wall12.png")

    EXPLOSION_IMAGE = love.graphics.newImage("explosion6.png")
    ZOMBIE_IMAGE = love.graphics.newImage("zombie.png")
    ZOMBIE_SHEET = love.graphics.newImage("zombieSheet.png")
    SOLDIER_IMAGE = love.graphics.newImage("images/worker.png")
    SOLDIER_2_IMAGE = love.graphics.newImage("soldier2.png")
    BULLET_IMAGE = love.graphics.newImage("bullet.png")
    TANK_SHELL = love.graphics.newImage("tankShell.png")
    M1_ABRAMS_BODY_IMAGE = love.graphics.newImage("tankBody.png")
    M1_ABRAMS_TURRET_IMAGE = love.graphics.newImage("tankTurret.png")

    HOUSE_IMAGE = love.graphics.newImage("images/house.png")
    HOUSE_2_IMAGE = love.graphics.newImage("images/house2.png")

    BUTTON_IMAGE = love.graphics.newImage("images/button.png")
    TREE_IMAGE = love.graphics.newImage("images/tree3.png")
    TREE_1_IMAGE = love.graphics.newImage("images/tree6.png")
    TREE_2_IMAGE = love.graphics.newImage("images/tree7.png")
    TREE_3_IMAGE = love.graphics.newImage("images/tree8.png")
    TREE_4_IMAGE = love.graphics.newImage("images/tree5.png")
    TREE_5_IMAGE = love.graphics.newImage("images/tree11.png")
    GRASS_IMAGE = love.graphics.newImage("images/grass.png")
--    TILE_IMAGE = love.graphics.newImage("images/grass1.png")
--    WINTER_IMAGE = love.graphics.newImage("winter.jpg")

--    DRAW_ENTITIES = {}
    SPRITE_BATCH = love.graphics.newSpriteBatch(ZOMBIE_IMAGE)
    ZOMBIE_QUAD = love.graphics.newQuad(0,  0,  64, 64, ZOMBIE_IMAGE:getDimensions())
--    table.insert(DRAW_ENTITIES, protagonist)

    TABS = {
        createTab("Residential", {
            createHouseButton(),
        }),
        createTab("Production", {

        }),
        createTab("Defense", {
            createStorageButton(),
        }),
    }

    local tileSize = GRID_SIZE / GRID_SCALE
    gridcanvas = love.graphics.newCanvas(TOTAL_TILES * tileSize, TOTAL_TILES * tileSize)
    love.graphics.setCanvas(gridcanvas)

    local baseNoiseScale = 2
    local noiseScale1 = 1 * baseNoiseScale
    local noiseScale2 = 2 * baseNoiseScale
    local noiseScale3 = 12 * baseNoiseScale
    local noiseOffsetX = math.random() * 10000
    local noiseOffsetY = math.random() * 10000
    for i = -GRID_TILES, GRID_TILES do
        grid[i] = {}
        for j = -GRID_TILES, GRID_TILES do
            local noiseX = i + noiseOffsetX
            local noiseY = j + noiseOffsetY
            local startingFactor = clamp(0, 0.01 * math.pow(dist(0, 0, i, j), 2), 1)
            local noise1 = love.math.noise(noiseX / noiseScale1, noiseY / noiseScale1)
            local noise2 = love.math.noise(noiseX / noiseScale2, noiseY / noiseScale2)
            local noise3 = love.math.noise(noiseX / noiseScale3, noiseY / noiseScale3)
            local noise = math.sqrt(math.sqrt(noise1 * noise2 * noise3)) * startingFactor

            grid[i][j] = {
                building = nil,
                units = 0,
                flowDir = 0,
                noise = noise,
                flow = {}
            }
            love.graphics.rectangle("line", (i + GRID_TILES) * tileSize, (j + GRID_TILES) * tileSize, tileSize, tileSize)

            if noise > 0.7 then
                local building = createTree(i, j)
                table.insert(buildings, building)
            end
        end
    end

    tileSize = GRASS_TILE_SIZE
    local grassTileCount = math.floor(TOTAL_TILES / (GRASS_SCALE * (GRASS_TILE_SIZE / GRID_SIZE))) + 1 + GRASS_PADDING_TILES * 2
    GRASS_CANVAS = love.graphics.newCanvas(grassTileCount * tileSize, grassTileCount * tileSize)
    love.graphics.setCanvas(GRASS_CANVAS)

    for i = 0, grassTileCount do
        for j = 0, grassTileCount do
            love.graphics.draw(GRASS_IMAGE, i * tileSize, j * tileSize)
        end
    end
    love.graphics.setCanvas()


    local building = createHouse(0, 0)
    table.insert(buildings, building)
    building:setGrid()

    cam:setScale(targetScale)

    FOW_SHADER = createFOWShader()

    calculateGrid()
end

function calculateGrid()
    local lights = {}
    for i = #buildings, 1, -1 do
        local building = buildings[i]
        if not building.isWall then
            table.insert(lights, {building.x / SHADOW_SIZE + 0.5, building.y / SHADOW_SIZE + 0.5})
        end
    end
    FOW_SHADER:send("lights", unpack(lights))
    calculateIntegrationField()
end

function calculateCostOfTravel(node, targetNode)
--    local dirToTarget = toDeg(angle(node.x, node.y, targetNode.x, targetNode.y))
--    local dirToOrigin = toDeg(angle(0, 0, targetNode.x, targetNode.y))

    local score = 1 --+ dist(targetNode.x, targetNode.y, 0, 0) / 40

--    local score = 1
--    if math.abs(targetNode.x) > 1 or math.abs(targetNode.y) > 1 then
--        score = dist(node.x, node.y, targetNode.x, targetNode.y) --+ math.abs(angleDiff(dirToTarget, dirToOrigin)) / 1
--    end

--    if targetNode.x == -1 and targetNode.y == -1 then
--        love.window.showMessageBox("test", tostring(dirToTarget))
--        love.window.showMessageBox("test", tostring(dirToOrigin))
--    end
--    local score = 1
--    local score = math.exp(math.abs(node.x - targetNode.x) + math.abs(node.y - targetNode.y), 4)

--    score = score + 0.2 / (math.abs(node.y) + 1)

    local tile = grid[targetNode.x][targetNode.y]

    if tile.building then
        score = score + 12
    end

    return score-- + tile.units / 12
end

function getNeighbors(node)
    local neighbors = {}

--    not (k == 1 and l == 1 and grid[i + 1][j].building and grid[i][j + 1].building) and
--    not (k == -1 and l == 1 and grid[i - 1][j].building and grid[i][j + 1].building) and
--    not (k == -1 and l == -1 and grid[i - 1][j].building and grid[i][j - 1].building) and
--    not (k == 1 and l == -1 and grid[i + 1][j].building and grid[i][j - 1].building)

--    if node.x - 1 >= -GRID_TILES then
--        table.insert(neighbors, { x = node.x - 1, y = node.y })
--        if node.y - 1 >= -GRID_TILES and not (grid[node.x - 1][node.y].building and grid[node.x][node.y - 1].building) then
--            table.insert(neighbors, { x = node.x - 1, y = node.y - 1 })
--        end
--    end
--    if node.x + 1 <= GRID_TILES then
--        table.insert(neighbors, { x = node.x + 1, y = node.y })
--        if node.y + 1 <= GRID_TILES and not (grid[node.x + 1][node.y].building and grid[node.x][node.y + 1].building) then
--            table.insert(neighbors, { x = node.x + 1, y = node.y + 1 })
--        end
--    end
--    if node.y - 1 >= -GRID_TILES then
--        table.insert(neighbors, { x = node.x, y = node.y - 1 })
--        if node.x + 1 <= GRID_TILES and not (grid[node.x + 1][node.y].building and grid[node.x][node.y - 1].building) then
--            table.insert(neighbors, { x = node.x + 1, y = node.y - 1 })
--        end
--    end
--    if node.y + 1 <= GRID_TILES then
--        table.insert(neighbors, { x = node.x, y = node.y + 1 })
--        if node.x - 1 >= -GRID_TILES and not (grid[node.x - 1][node.y].building and grid[node.x][node.y + 1].building) then
--            table.insert(neighbors, { x = node.x - 1, y = node.y + 1 })
--        end
--    end

    if node.x - 1 >= -GRID_TILES then
        table.insert(neighbors, { x = node.x - 1, y = node.y })
        if node.y - 1 >= -GRID_TILES then
            table.insert(neighbors, { x = node.x - 1, y = node.y - 1 })
        end
    end
    if node.x + 1 <= GRID_TILES then
        table.insert(neighbors, { x = node.x + 1, y = node.y })
        if node.y + 1 <= GRID_TILES then
            table.insert(neighbors, { x = node.x + 1, y = node.y + 1 })
        end
    end
    if node.y - 1 >= -GRID_TILES then
        table.insert(neighbors, { x = node.x, y = node.y - 1 })
        if node.x + 1 <= GRID_TILES then
            table.insert(neighbors, { x = node.x + 1, y = node.y - 1 })
        end
    end
    if node.y + 1 <= GRID_TILES then
        table.insert(neighbors, { x = node.x, y = node.y + 1 })
        if node.x - 1 >= -GRID_TILES then
            table.insert(neighbors, { x = node.x - 1, y = node.y + 1 })
        end
    end

    return neighbors
end

function resetFields()
    for i = -GRID_TILES, GRID_TILES do
        for j = -GRID_TILES, GRID_TILES do
            grid[i][j].weight = 999
            grid[i][j].tight = false
        end
    end
end

function calculateFlow()
    for i = -GRID_TILES, GRID_TILES do
        for j = -GRID_TILES, GRID_TILES do
--            local lowest = 999
--            local bestX = 0
--            local bestY = 0
--
--            for k = -1, 1 do
--                for l = -1, 1 do
--                    if not (k == 0 and l == 0) then
--                        local x = i + k
--                        local y = j + l
--                        if x >= -GRID_TILES and x <= GRID_TILES and y >= -GRID_TILES and y <= GRID_TILES then
--                            if
--                                not (k == 1 and l == 1 and grid[i + 1][j].building and grid[i][j + 1].building) and
--                                not (k == -1 and l == 1 and grid[i - 1][j].building and grid[i][j + 1].building) and
--                                not (k == -1 and l == -1 and grid[i - 1][j].building and grid[i][j - 1].building) and
--                                not (k == 1 and l == -1 and grid[i + 1][j].building and grid[i][j - 1].building)
--                            then
--                                local weight = grid[x][y].weight
--                                if weight < lowest then
--                                    lowest = weight
--                                    bestX = k
--                                    bestY = l
--                                end
--                            end
--                        end
--                    end
--                end
--            end
            local lowest = 999
            local secondLowest = 999
            local thirdLowest = 999
            local bestX = 0
            local bestY = 0
            local secondBestX = 0
            local secondBestY = 0
            local currentWeight = grid[i][j].weight

            local options = {}

            for k = -1, 1 do
                for l = -1, 1 do
                    if not (k == 0 and l == 0) then
                        local x = i + k
                        local y = j + l

                        if x >= -GRID_TILES and x <= GRID_TILES and y >= -GRID_TILES and y <= GRID_TILES then
                            if grid[x][y].building then
                                grid[i][j].tight = true
                            end

--                            if
--                                not (k == 1 and l == 1 and grid[i + 1][j].building and grid[i][j + 1].building) and
--                                not (k == -1 and l == 1 and grid[i - 1][j].building and grid[i][j + 1].building) and
--                                not (k == -1 and l == -1 and grid[i - 1][j].building and grid[i][j - 1].building) and
--                                not (k == 1 and l == -1 and grid[i + 1][j].building and grid[i][j - 1].building)
--                            then
                                local dirToTarget = toDeg(angle(i, j, x, y))
                                local dirToOrigin = toDeg(angle(i, j, 0, 0))
                                local weight = grid[x][y].weight + math.abs(angleDiff(dirToTarget, dirToOrigin)) / 1000
--                                local weight = grid[x][y].weight + dist(x, y, 0, 0) / 100
    --                            love.window.showMessageBox("test", tostring(math.abs(angleDiff(dirToTarget, dirToOrigin))))
                                table.insert(options, {
                                    weight = weight,
                                    x = k,
                                    y = l
                                })
--                            end
                        end
                    end
                end
            end

            table.sort(options, weightSort)

            grid[i][j].x = toWorldSpace(i)
            grid[i][j].y = toWorldSpace(j)
            grid[i][j].flow = {
                {
                    dir = angle(0, 0 , options[1].x, options[1].y),
                    nextTile = grid[i + options[1].x][j + options[1].y],
                },
                {
                    dir = angle(0, 0 , options[2].x, options[2].y),
                    nextTile = grid[i + options[2].x][j + options[2].y],
                },
                {
                    dir = angle(0, 0 , options[3].x, options[3].y),
                    nextTile = grid[i + options[3].x][j + options[3].y],
                }
            }
        end
    end
end

function containsNode(nodes, node)
    local found = false

    for i = 1, #nodes do
        local currentNode = nodes[i]
        if currentNode.x == node.x and currentNode.y == node.y then
            found = true
        end
    end

    return found
end

function calculateIntegrationField()
    SEARCH_NODES = {
        {
            x = 0,
            y = 0,
        }
    }

    resetFields()

    for i = 1, #SEARCH_NODES, 1 do
        local node = SEARCH_NODES[i]
        grid[node.x][node.y].weight = 0
    end
end

function processField()
    local searches = 0
    local someSearchNodes = #SEARCH_NODES > 0

    while #SEARCH_NODES > 0 and searches < MAX_SEARCHES  do
        local currentNode = SEARCH_NODES[1]
        table.remove(SEARCH_NODES, 1)

        local weight = grid[currentNode.x][currentNode.y].weight
        local neighbors = getNeighbors(currentNode)

        searches = searches + 1

        for i = 1, #neighbors do
            local neighbor = neighbors[i]

            --Calculate the new cost of the neighbor node
            --based on the cost of the current node and the weight of the next node
            local combinedCost = weight + calculateCostOfTravel(currentNode, neighbor)

            if combinedCost < grid[neighbor.x][neighbor.y].weight then
                grid[neighbor.x][neighbor.y].weight = combinedCost

                if not containsNode(SEARCH_NODES, neighbor) then
                    table.insert(SEARCH_NODES, neighbor)
                end
            end
        end


        if #SEARCH_NODES == 0 then
            calculateFlow()
        end
    end
end

function love.wheelmoved(x, y)
    if y > 0 then
        targetScale = cam:getScale() + 0.3 * cam:getScale()
    elseif y < 0 then
        targetScale = cam:getScale() - 0.3 * cam:getScale()
    end

    targetScale = clamp(0.7, targetScale, 3)

--    cam:setPosition(x, y)
    local mx, my = love.mouse.getPosition()
    local xDiff = love.graphics.getWidth() / 2 - mx
    local yDiff = love.graphics.getHeight() / 2 - my

    local currentX, currentY = cam:getPosition()
    targetCamX = currentX - (xDiff * sign(y) / 4) / cam:getScale()
    targetCamY = currentY - (yDiff * sign(y) / 4) / cam:getScale()
end

function toGridSpace(pos)
    pos = pos / GRID_SIZE
    return round(pos)
end

function toWorldSpace(pos)
    return pos * GRID_SIZE
end

function doesOverlap(gridX, gridY, shape)
    for j = 0, #shape - 1 do
        local row = shape[j + 1]
        for i = 0, #row - 1 do
            if
                gridX + i <= GRID_TILES and gridX + i >= -GRID_TILES and
                gridY + j <= GRID_TILES and gridY + j >= -GRID_TILES
            then
                local building = grid[gridX + i][gridY + j].building
                if building then
                    return true
                end
            else
               return true
            end
        end
    end
end

function love.mousepressed(x, y, button, istouch)
    local mx, my = love.mouse.getPosition()
    local worldMx, worldMy = cam:toWorld(mx, my)

    if button == 1 then
--        local spread = 200
--        local count = 80
--        for i = 1, count, 1 do
--            for j = 1, count, 1 do
--                table.insert(enemyUnits, createZombie(worldMx + math.random() * spread, worldMy + math.random() * spread))
--            end
--        end

        local clickedOnNothing = true

        if SELECTED then
            SELECTED:click()
            clickedOnNothing = false
        end


        if SELECTED_TAB then
            for i = 1, #SELECTED_TAB.buttons do
                local button = SELECTED_TAB.buttons [i]
                if button.hovered then
                    button:click()
                    clickedOnNothing = false
                end
            end
        end

        for i = 1, #TABS do
            local tab = TABS[i]
            if tab.hovered then
                tab:click()
                clickedOnNothing = false
            end
        end

        if clickedOnNothing then
            SELECTED_TAB = nil
        end
--        local gridX = toGridSpace(worldMx)
--        local gridY = toGridSpace(worldMy)
--
--        local shape = {
--            {1},
--        }
--
--        local overlaps = doesOverlap(gridX, gridY, shape)
--
--        if not overlaps then
----            local building = createWall(gridX, gridY, gridX, gridY)
----            table.insert(buildings, building)
----
----            grid[gridX][gridY].building = building
--
--            local building = createWall(gridX, gridY)
--
--            table.insert(buildings, building)
--
--            calculateGrid()
--        end
    elseif button == 2 then
        SELECTED = nil

--        local gridX = toGridSpace(worldMx)
--        local gridY = toGridSpace(worldMy)
--
--        local occupied = grid[gridX][gridY].building
--        if not occupied then
--            local tree = createTree(gridX, gridY)
--            table.insert(buildings, tree)
--        end


--        local mx, my = love.mouse.getPosition()
--        local worldMx, worldMy = cam:toWorld(mx, my)
--        table.insert(enemyUnits, createZombie(worldMx, worldMy, false, createM1911(), ZOMBIE_SHEET))

--        table.insert(explosions, createExplosion(worldMx, worldMy, EXPLOSION_IMAGE))

        --        local spread = 200
--        local count = 8
--        for i = 1, count, 1 do
--            for j = 1, count, 1 do
--                table.insert(enemyUnits, createSoldier(worldMx - spread / 2 + i * spread / count, worldMy - spread / 2 + j * spread / count, false, createM1911(), SOLDIER_IMAGE))
--            end
--        end
    end


--    local ammo = createTankShell()
--
--    local targetX = worldMx + 600
--    local targetY = worldMy - 600
--
--    local dist = dist(worldMx, worldMy, targetX, targetY)
--    local launchSpeed = 1200
--
--    local input = WORLD_GRAVITY * dist / math.pow(launchSpeed, 2)
--
--        local launchAngle = 0.5 * math.asin(input) -- no height
--        local groundSpeed = launchSpeed * math.cos(launchAngle)
--        local zVel = launchSpeed * math.sin(launchAngle)
--
--        local duration = dist / groundSpeed
--        local vx = (targetX - worldMx) / duration
--        local vy = (targetY - worldMy) / duration
--
--        table.insert(bullets, createBullet(worldMx, worldMy, 0, vx, vy, zVel, duration, toRad(45), nil, false, ammo))

--    local spread = 200
--    local count = 2
--    for i = 1, count, 1 do
--        for j = 1, count, 1 do
--            table.insert(enemyUnits, createM1Abrams(worldMx - spread / 2 + i * spread / count, worldMy - spread / 2 + j * spread / count, false))
--        end
--    end
end

function love.update(dt)
    time = time + dt
    offsetX = math.sin(time)

    processField()

    if SELECTED then
        SELECTED:update()
    end


    -- Border Pan
    local mx, my = love.mouse.getPosition()
    local xDiff = (love.graphics.getWidth() / 2 - mx) / love.graphics.getWidth()
    local yDiff = (love.graphics.getHeight() / 2 - my) / love.graphics.getHeight()
    local shouldPan = false

    if
        (mx < PAN_PADDING and my < love.graphics.getHeight() * 0.75) or mx > love.graphics.getWidth() - PAN_PADDING or
        my < PAN_PADDING or (my > love.graphics.getHeight() - PAN_PADDING and
        mx > love.graphics.getWidth() / 3)
    then
        shouldPan = true
    end

    if shouldPan then
        local currentX, currentY = cam:getPosition()
        targetCamX = currentX - (xDiff * PAN_SPEED * dt) / cam:getScale()
        targetCamY = currentY - (yDiff * PAN_SPEED * dt) / cam:getScale()
    end

--    if updateFieldCount > UPDATE_FIELD_DURATION then
--        updateFieldCount = 0
--        calculateIntegrationField()
--    else
--        updateFieldCount = updateFieldCount + 1 * dt
--    end

--    local down = love.mouse.isDown(1)
--    if down then
--        local mx, my = love.mouse.getPosition()
--        local worldMx, worldMy = cam:toWorld(mx, my)
--        table.insert(enemyUnits, createZombie(worldMx + (math.random() - 0.5) * 80, worldMy + (math.random() - 0.5) * 80))
--    end

--    local mx, my = love.mouse.getPosition()
--    local worldMx, worldMy = cam:toWorld(mx, my)

--    SPRITE_BATCH:clear()
--    for i = #playerUnits, 1, -1 do
--        local unit = playerUnits[i]
--        local shouldDelete = unit:update(dt, time)
--        if shouldDelete then
--            table.remove(playerUnits, i)
--        else
--            SPRITE_BATCH:add(ZOMBIE_QUAD, unit.x, unit.y, unit.angle)
--        end
--    end
--    for i = #enemyUnits, 1, -1 do
--        local unit = enemyUnits[i]
--        local shouldDelete = unit:update(dt, i)
--        if shouldDelete then
--            table.remove(enemyUnits, i)
--        else
--            SPRITE_BATCH:add(ZOMBIE_QUAD, unit.x, unit.y, unit.angle, 0.5, 0.5, 32, 32)
--        end
--    end

--    table.sort(enemyUnits, function(entity1, entity2)
--        if entity1.y ~= entity2.y then
--   12         return entity1.y < entity2.y
--        end
--        return 0
--    end)

    for i = #playerUnits, 1, -1 do
        local shouldDelete = playerUnits[i]:update(dt, time)
        if shouldDelete then
            table.remove(playerUnits, i)
        end
    end

    for i = #enemyUnits, 1, -1 do
        local shouldDelete = enemyUnits[i]:update(dt, i)
        if shouldDelete then
            table.remove(enemyUnits, i)
        end
    end

    for i = #bullets, 1, -1 do
        local shouldDelete = bullets[i]:update(dt)
        if shouldDelete then
            table.remove(bullets, i)
        end
    end

    for i = #explosions, 1, -1 do
        local shouldDelete = explosions[i]:update(dt)
        if shouldDelete then
            table.remove(explosions, i)
        end
    end

    -- optimize
    for i = #buildings, 1, -1 do
        local shouldDelete = buildings[i]:update(dt)
        if shouldDelete then
            table.remove(buildings, i)
        end
    end

    local windowBottom = love.graphics:getHeight()


    for i = #TABS, 1, -1 do
        TABS[i]:update(i * 150 - 130, windowBottom - 50)
    end

    if SELECTED_TAB then
        for i = #SELECTED_TAB.buttons, 1, -1 do
            SELECTED_TAB.buttons[i]:update(-20 + i * 120, windowBottom - 120)
        end
    end

    local scale = lerp(cam:getScale(), targetScale, 0.05)
    cam:setScale(scale)

    local currentX, currentY = cam:getPosition()

    local camX = lerp(currentX, targetCamX, 0.05)
    local camY = lerp(currentY, targetCamY, 0.05)
    cam:setPosition(camX, camY)

    hud[1] = "Population: "..tostring(POPULATION)
    hud[2] = "Money: "..tostring(MONEY)

    debug[1] = "Current FPS: "..tostring(love.timer.getFPS())
    debug[2] = "soldiers: "..tostring(#playerUnits)
    debug[3] = "explosions: "..tostring(#explosions)
    debug[4] = "bullets: "..tostring(#bullets)
    debug[5] = "target scale: "..tostring(targetScale)
end

local function drawCameraStuff(l,t,w,h)

    love.graphics.draw(GRASS_CANVAS,
        -GRID_SIZE * (GRID_TILES + 0.5) - GRASS_PADDING_TILES * GRASS_TILE_SIZE * GRASS_SCALE,
        -GRID_SIZE * (GRID_TILES + 0.5) - GRASS_PADDING_TILES * GRASS_TILE_SIZE * GRASS_SCALE,
        0, GRASS_SCALE, GRASS_SCALE)

    -- Draw grid

    if SELECTED then
        local scale = math.min(cam:getScale() / 2 - 0.1, 0.25)
        love.graphics.setColor(1, 1, 1, scale)
        love.graphics.draw(gridcanvas, -GRID_SIZE * (GRID_TILES + 0.5), -GRID_SIZE * (GRID_TILES + 0.5), 0, GRID_SCALE, GRID_SCALE, 0, 0)
        love.graphics.setColor(1, 1, 1, 1)
    end

    for i = 1, #playerUnits, 1 do
        playerUnits[i]:draw()
    end
    for i = 1, #enemyUnits, 1 do
        enemyUnits[i]:draw()
    end
    for i = 1, #buildings, 1 do
        buildings[i]:draw()
    end

--    love.graphics.draw(SPRITE_BATCH)

    for i = 1,#bullets,1 do
        bullets[i]:draw()
    end
    for i = 1, #buildings, 1 do
        buildings[i]:drawHealthbar()
    end

    love.graphics.setBlendMode("add")
    for i = 1,#explosions,1 do
        explosions[i]:draw()
    end
    love.graphics.setBlendMode("alpha")

    if SELECTED then
        SELECTED:draw()
    end

--     Grid debug
--    for i = -GRID_TILES, GRID_TILES, 1 do
--        for j = -GRID_TILES, GRID_TILES, 1 do
----            local value = grid[i][j].weight
----            love.graphics.print(tostring(roundDecimal(value, 2)), i * GRID_SIZE, j * GRID_SIZE)
----            local value = grid[i][j].tight
----            love.graphics.print(tostring(value), i * GRID_SIZE, j * GRID_SIZE)
--
----            local value = grid[i][j].noise
----            love.graphics.setColor(value, value, value, 0.2)
----            love.graphics.rectangle('fill',i * GRID_SIZE, j * GRID_SIZE, 64, 64)
--
--            local flow = grid[i][j].flow
--            if flow[1] then
--                if flow[1].x == 0 and flow[1].y == 0 then
--                    love.graphics.circle("fill", i * GRID_SIZE, j * GRID_SIZE, 2, 8)
--                else
--    --                love.graphics.line(i * GRID_SIZE, j * GRID_SIZE, (i + flow.x / 3) * GRID_SIZE, (j + flow.y / 3) * GRID_SIZE)
--                    love.graphics.line(i * GRID_SIZE, j * GRID_SIZE, flow[1].nextTile.x, flow[1].nextTile.y)
--                end
--            end
--        end
--    end

--    love.graphics.setShader(FOW_SHADER) --draw something here
--    love.graphics.draw(SHADOW_IMAGE, -SHADOW_SIZE / 2, -SHADOW_SIZE / 2, 0, SHADOW_SIZE, SHADOW_SIZE)
--    love.graphics.setShader()

end

function love.draw()
    cam:draw(drawCameraStuff)

    for i = 1, #TABS do
        TABS[i]:draw()
    end

    if SELECTED_TAB then
        for i = 1, #SELECTED_TAB.buttons do
            SELECTED_TAB.buttons[i]:draw()
        end
    end

    for i = 1, #hud, 1 do
        love.graphics.print(hud[i], 10 + i * 150, 30)
    end

    for i = 1, #debug, 1 do
        love.graphics.print(debug[i], love.graphics.getWidth() - 200, 60 + i * 20)
    end
end

function getClosest(x, y, targets)
    local lowestRange = 99999
    local closest
    local fuzziness = 200

    for i = 1, #targets, 1 do
        local enemy = targets[i]
        local dist = dist(x, y, enemy.x + (math.random() - 0.5) * fuzziness, enemy.y + (math.random() - 0.5) * fuzziness)
        if dist < lowestRange then
            lowestRange = dist
            closest = enemy
        end
    end

    return closest
end

function getWithinRadius(x, y, radius, targets)
    local items = {}

    for i = 1, #targets, 1 do
        local unit = targets[i]
        local dist = dist(x, y, unit.x , unit.y)
        if dist < radius then
            table.insert(items, unit)
        end
    end

    return items
end