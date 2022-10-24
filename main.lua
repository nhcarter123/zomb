require("units/unit")
require("units/archer")
require("units/worker")
require("units/zombie")
Ogre = require("units/ogre")
require("units/tanks/tank")
require("units/tanks/m1Abrams")

require("miscMath")
require("animation")
require("explosion")

require("buttons/button")
require("buttons/tab")
Buttons = require("buttons/buttons")

require("guns/gun")
require("guns/bow")
Catapult = require("guns/catapult")
require("guns/m1911")
require("guns/m1AbramsTurret")

require("ammo/bullet")
require("ammo/tankShell")
require("ammo/45acp")
require("ammo/arrow")
Bullets = require("ammo/bullets")

Building = require("buildings/building")
WoodWall = require("buildings/woodWall")
StoneWall = require("buildings/stoneWall")
Tower = require("buildings/outpost")
CatapultTower = require("buildings/catapultTower")
House = require("buildings/house")
WoodCutterHut = require("buildings/woodCutterHut")
MiningCamp = require("buildings/miningCamp")
Tree = require("buildings/tree")
Rock = require("buildings/rock")
Storage = require("buildings/storage")
Farm = require("buildings/farm")

require("shaders/fowShader")
require("shaders/outlineShader")
DropShadowShader = require("shaders/dropShadowShader")
LineShader = require("shaders/lineShader")

Selected = require("selected")

Gamera = require("gamera")


DescriptionPanel = require("descriptionPanel")
TimeManager = require("timeManager")
EnemyManager = require("enemyManager")
CloudManager = require("cloudManager")
PopulationManager = require("populationManager")
MapManager = require("mapManager")

love.window.setMode(600, 600, {
    fullscreen = true,
    borderless = true
})
--love.window.setFullscreen(true)

targetScale = 1
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
GRASS_PADDING_TILES = 0
GRID_TILES = 30
TOTAL_TILES = 2 * GRID_TILES + 1

updateFieldCount = 0
UPDATE_FIELD_DURATION = 4

WORLD_GRAVITY = 9.8 * 40
targetCamX = 0
targetCamY = 0
camX = targetCamX
camY = targetCamY
PAN_PADDING = 100
PAN_SPEED = 10000
worldWidth = 1600 * 10
worldHeight = 900 * 10
cam = Gamera.new(-worldWidth / 2, -worldHeight / 2, worldWidth, worldHeight)

SHADOW_SIZE = 5000

SEARCH_NODES = {}
MAX_SEARCHES = 2000

MAX_POPULATION = 0
MAX_HAPPINESS = 100

POPULATION = 0
HAPPINESS = 50

---- Resources
WOOD = 60
FOOD = 20
STONE = 5
WOOD_VALUE = 1
FOOD_VALUE = 1
STONE_VALUE = 2

FOOD_MAX_STACK_SIZE = 50
WOOD_MAX_STACK_SIZE = 50
STONE_MAX_STACK_SIZE = 50

SELECTED = nil
SELECTED_TAB = nil

WALL_PIECE_CACHE = {
    Wood = {},
    Stone = {},
}

CURRENT_BUTTONS = {}

HOVERED_GRID_X = 0
HOVERED_GRID_Y = 0
SELECTED_TILES = {}
SAVED_SELECTED_TILES = {}

SAVED_SELECTED_TILES = {}
ICON_ORIGIN_X = 64
ICON_ORIGIN_Y = 64
--     love.window.showMessageBox("test", tostring(M1_ABRAMS_BODY_IMAGE))

function love.load()
    math.randomseed(os.time())
--    love.graphics.setDefaultFilter( 'nearest', 'nearest' )

--    fb = gr.newFramebuffer(love.graphics.getWidth(), love.graphics.getHeight())
--    love.graphics.setBackgroundColor(0.7, 0.5, 0.4)

    love.graphics.setBackgroundColor(46 / 255, 50 / 255, 35 / 255)
--    love.graphics.setBackgroundColor(1, 0.8, 0.7)

    SHADOW_IMAGE = love.graphics.newImage("shadow.png")
    BUNKER_IMAGE = love.graphics.newImage("bunker.png")
--    SANDBAGS_IMAGE = love.graphics.newImage("sandbags.png")

    ROCK_4_IMAGE = love.graphics.newImage("images/rock4.png")
    ROCK_5_IMAGE = love.graphics.newImage("images/rock5.png")
    ROCK_6_IMAGE = love.graphics.newImage("images/rock6.png")
    ROCK_7_IMAGE = love.graphics.newImage("images/rock7.png")

    ---- Walls
    WOOD_WALL_1_IMAGE = love.graphics.newImage("images/wallPiece1.png")
    WOOD_WALL_2_IMAGE = love.graphics.newImage("images/wallPiece2.png")
    WOOD_WALL_3_IMAGE = love.graphics.newImage("images/wallPiece3.png")
    STONE_WALL_1_IMAGE = love.graphics.newImage("images/stoneWall1.png")
    STONE_WALL_2_IMAGE = love.graphics.newImage("images/stoneWall2.png")
    STONE_WALL_3_IMAGE = love.graphics.newImage("images/stoneWall3.png")


    EXPLOSION_IMAGE = love.graphics.newImage("explosion6.png")

    ---- Enemies
    ZOMBIE_IMAGE = love.graphics.newImage("images/zombie.png")
    OGRE_IMAGE = love.graphics.newImage("images/ogre.png")

    ZOMBIE_SHEET = love.graphics.newImage("zombieSheet.png")
    ARCHER_IMAGE = love.graphics.newImage("images/archer.png")
    SOLDIER_IMAGE = love.graphics.newImage("images/worker.png")
    SOLDIER_2_IMAGE = love.graphics.newImage("soldier2.png")

    BULLET_IMAGE = love.graphics.newImage("bullet.png")
    ARROW_IMAGE = love.graphics.newImage("images/arrow.png")
    STONE_PROJECTILE_IMAGE = love.graphics.newImage("images/stoneProjectile.png")

    TANK_SHELL = love.graphics.newImage("tankShell.png")
    M1_ABRAMS_BODY_IMAGE = love.graphics.newImage("tankBody.png")
    M1_ABRAMS_TURRET_IMAGE = love.graphics.newImage("tankTurret.png")

    HOUSE_IMAGE = love.graphics.newImage("images/house.png")
    HOUSE_2_IMAGE = love.graphics.newImage("images/house2.png")
    WOOD_CUTTER_HUT_IMAGE = love.graphics.newImage("images/woodCutterHut.png")
    MINING_CAMP_IMAGE = love.graphics.newImage("images/miningTent.png")

    STORAGE_FLOOR_IMAGE = love.graphics.newImage("images/storageFloor.png")
    STORAGE_ROOF_IMAGE = love.graphics.newImage("images/storageRoof.png")

    STUMP_IMAGE = love.graphics.newImage("images/stump.png")
    TREE_IMAGE = love.graphics.newImage("images/tree3.png")

    TREE_1_IMAGE = love.graphics.newImage("images/tree5.png")
    TREE_2_IMAGE = love.graphics.newImage("images/tree11.png")
    TREE_3_IMAGE = love.graphics.newImage("images/tree12.png")

    CLOUD_1_IMAGE = love.graphics.newImage("images/cloud.png")
    CLOUD_2_IMAGE = love.graphics.newImage("images/cloud2.png")
    CLOUD_3_IMAGE = love.graphics.newImage("images/cloud3.png")

    TOWER_IMAGE = love.graphics.newImage("images/tower.png")
    FARM_IMAGE = love.graphics.newImage("images/farm.png")
    GRASS_IMAGE = love.graphics.newImage("images/grass.png")

    ---- Icons
    REMOVE_ICON_IMAGE = love.graphics.newImage("images/icons/remove.png")
    WARNING_ICON_IMAGE = love.graphics.newImage("images/icons/warning.png")
    PAUSE_ICON_IMAGE = love.graphics.newImage("images/icons/pause.png")
    PLAY_ICON_IMAGE = love.graphics.newImage("images/icons/play.png")
    QUESTION_MARK_ICON_IMAGE = love.graphics.newImage("images/icons/questionMark.png")
    BOSS_ICON_IMAGE = love.graphics.newImage("images/icons/boss.png")
    ENEMY_ICON_IMAGE = love.graphics.newImage("images/icons/enemy.png")
    BREAD_ICON_IMAGE = love.graphics.newImage("images/icons/bread.png")
    PERSON_ICON_IMAGE = love.graphics.newImage("images/icons/person.png")
    STONES_ICON_IMAGE = love.graphics.newImage("images/icons/stones.png")
    WOOD_ICON_IMAGE = love.graphics.newImage("images/icons/wood.png")
    TREASURE_ICON_IMAGE = love.graphics.newImage("images/icons/treasure.png")
    HOME_ICON_IMAGE = love.graphics.newImage("images/icons/home.png")
    CIRCLED_ICON_IMAGE = love.graphics.newImage("images/icons/circled.png")

    ---- Resource Stacks
    ---- Wood
    LUMBER_IMAGE_1 = love.graphics.newImage("images/lumber1.png")
    LUMBER_IMAGE_2 = love.graphics.newImage("images/lumber2.png")
    LUMBER_IMAGE_3 = love.graphics.newImage("images/lumber3.png")
    ---- Bread
    BREAD_IMAGE_1 = love.graphics.newImage("images/bread1.png")
    BREAD_IMAGE_2 = love.graphics.newImage("images/bread2.png")
    BREAD_IMAGE_3 = love.graphics.newImage("images/bread3.png")
    ---- Stone
    STONE_IMAGE_1 = love.graphics.newImage("images/stone1.png")
    STONE_IMAGE_2 = love.graphics.newImage("images/stone2.png")
    STONE_IMAGE_3 = love.graphics.newImage("images/stone3.png")


--    TILE_IMAGE = love.graphics.newImage("images/grass1.png")
--    WINTER_IMAGE = love.graphics.newImage("winter.jpg")

--    DRAW_ENTITIES = {}
    SPRITE_BATCH = love.graphics.newSpriteBatch(ZOMBIE_IMAGE)
    ZOMBIE_QUAD = love.graphics.newQuad(0,  0,  64, 64, ZOMBIE_IMAGE:getDimensions())
--    table.insert(DRAW_ENTITIES, protagonist)

    ---- Init buttons
    FORBID_BUTTON = Buttons.createForbidButton()
    ---- Init tabs
    TABS = {
        createTab("Residential", {
            Buttons.createHouseButton(),
        }),
        createTab("Production", {
            Buttons.createFarmButton(),
            Buttons.createWoodCutterHutButton(),
            Buttons.createMiningCampButton(),
            Buttons.createStorageButton(),
        }),
        createTab("Defense", {
            Buttons.createWoodWallButton(),
            Buttons.createStoneWallButton(),
            Buttons.createOutpostButton(),
            Buttons.createCatapultTowerButton(),
        }),
    }

    tileSize = GRASS_TILE_SIZE
    local grassTileCount = math.floor(TOTAL_TILES / (GRASS_SCALE * (GRASS_TILE_SIZE / GRID_SIZE))) + 1 + GRASS_PADDING_TILES * 2
    GRASS_CANVAS = love.graphics.newCanvas(grassTileCount * tileSize, grassTileCount * tileSize)
    love.graphics.setCanvas(GRASS_CANVAS)

    for i = 0, grassTileCount do
        for j = 0, grassTileCount do
            love.graphics.draw(GRASS_IMAGE, i * tileSize, j * tileSize)
        end
    end

    local tileSize = GRID_SIZE / GRID_SCALE
    gridcanvas = love.graphics.newCanvas(TOTAL_TILES * tileSize, TOTAL_TILES * tileSize)

    love.graphics.setCanvas(gridcanvas)

    local baseNoiseScale = 2
    local noiseScale1 = 1 * baseNoiseScale
    local noiseScale2 = 2 * baseNoiseScale
    local noiseScale6 = 6 * baseNoiseScale
    local noiseScale12 = 12 * baseNoiseScale
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
            local noise6 = love.math.noise(noiseX / noiseScale6, noiseY / noiseScale6)
            local noise12 = love.math.noise(noiseX / noiseScale12, noiseY / noiseScale12)

            local rockNoise = noise6 * startingFactor
            local treeNoise = math.sqrt(math.sqrt(math.sqrt(noise1 * noise2 * noise12 * (1 - rockNoise)))) * startingFactor

            if
                i == -GRID_TILES or i == GRID_TILES or
                j == -GRID_TILES or j == GRID_TILES
            then
                rockNoise = 0
                treeNoise = 0
            end

            grid[i][j] = {
                building = nil,
                units = 0,
                flowDir = 0,
                flow = {
                    nextTile = {
                        units = 0
                    }
                }
            }

            love.graphics.rectangle("line", (i + GRID_TILES) * tileSize, (j + GRID_TILES) * tileSize, tileSize, tileSize)

            if treeNoise > 0.82 then
                local building = Tree.create(i, j)
                table.insert(buildings, building)
                building:init()
            end

            if rockNoise > 0.95 then
                local building = Rock.create(i, j)
                table.insert(buildings, building)
                building:init()
--                love.graphics.setCanvas(GRASS_CANVAS)
--                if math.random() > 0.5 then
--                    love.graphics.draw(ROCK_2_IMAGE, (i + GRID_TILES) * GRID_SIZE, (j + GRID_TILES) * GRID_SIZE, 0, 0.5, 0.5, 0, 0)
--                else
--                    love.graphics.draw(ROCK_3_IMAGE, (i + GRID_TILES) * GRID_SIZE, (j + GRID_TILES) * GRID_SIZE, 0, 0.5, 0.5, 0, 0)
--                end
--                love.graphics.setCanvas(gridcanvas)
            end
        end
    end

    DEBRIS_CANVAS_SCALE = 1
    DEBRIS_CANVAS = love.graphics.newCanvas(2 * GRID_SIZE * GRID_TILES / DEBRIS_CANVAS_SCALE, 2 * GRID_SIZE * GRID_TILES / DEBRIS_CANVAS_SCALE)

    love.graphics.setCanvas()


    local house = House.create(-2, 0)
    table.insert(buildings, house)
    house:init()
    local house = House.create(-1, 0)
    table.insert(buildings,house)
    house:init()

    local storage = Storage.create(1, 0)
    table.insert(buildings, storage)
    storage:init()

    cam:setScale(targetScale)

    local outlineThickness = 0.03
    OUTLINE_SHADER = createOutlineShader()
    OUTLINE_SHADER:send("opacity", 0.7)
    OUTLINE_SHADER:send("stepSize", { outlineThickness, outlineThickness })

    FOW_SHADER = createFOWShader()

    calculateGrid()

    TimeManager:setShadowLength()

    CloudManager:init()
    MapManager:generate()
end

function calculateGrid()
    local lights = {}
    for i = #buildings, 1, -1 do
        local building = buildings[i]
        if not building.isWall and not building.isTree and not building.isStone then
            table.insert(lights, {building.x / SHADOW_SIZE + 0.5, building.y / SHADOW_SIZE + 0.5})
        end
    end

--    love

    FOW_SHADER:send("lights", unpack(lights))

--    local lights = {}
--
--    for i = #buildings, 1, -1 do
--        local building = buildings[i]
--        if not building.isWall and not building.isTree and not building.isRock then
--            table.insert(lights, { building.x / SHADOW_SIZE + 0.5, building.y / SHADOW_SIZE + 0.5 })
--        end
--    end
--    FOW_SHADER:send("lights", unpack(lights) or {0, 0})
--
----    FOW_SHADER:send("positions", {10, 10}, {20, 20})
--
--    FOW_SHADER:send("shadows", unpack(shadows))
--    FOW_SHADER:send("positions", unpack(positions))

--    FOW_SHADER:send("shadows", TREE_1_IMAGE, HOUSE_2_IMAGE)
--    FOW_SHADER:send("positions", {1, 1}, {5, 5})

    calculateIntegrationField()
end

function calculateCostOfTravel(node, targetNode)
--    local dirToTarget = toDeg(angle(node.x, node.y, targetNode.x, targetNode.y))
--    local dirToOrigin = toDeg(angle(0, 0, targetNode.x, targetNode.y))

--    local score = 1 --+ dist(targetNode.x, targetNode.y, 0, 0) / 40
    local score = 1--dist(targetNode.x, targetNode.y, node.x, node.y)

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
    local previousTile = grid[node.x][node.y]

    if tile.building then
        score = score + 5 * tile.building.health / 100
    end

    return score + previousTile.units / 20 + tile.units / 35
end

function getNeighbors(node)
    local neighbors = {}

--    not (k == 1 and l == 1 and grid[i + 1][j].building and grid[i][j + 1].building) and
--    not (k == -1 and l == 1 and grid[i - 1][j].building and grid[i][j + 1].building) and
--    not (k == -1 and l == -1 and grid[i - 1][j].building and grid[i][j - 1].building) and
--    not (k == 1 and l == -1 and grid[i + 1][j].building and grid[i][j - 1].building)

    if node.x - 1 >= -GRID_TILES then
        table.insert(neighbors, { x = node.x - 1, y = node.y })
--        if node.y - 1 >= -GRID_TILES and not (grid[node.x - 1][node.y].building and grid[node.x][node.y - 1].building) then
--            table.insert(neighbors, { x = node.x - 1, y = node.y - 1 })
--        end
    end
    if node.x + 1 <= GRID_TILES then
        table.insert(neighbors, { x = node.x + 1, y = node.y })
--        if node.y + 1 <= GRID_TILES and not (grid[node.x + 1][node.y].building and grid[node.x][node.y + 1].building) then
--            table.insert(neighbors, { x = node.x + 1, y = node.y + 1 })
--        end
    end
    if node.y - 1 >= -GRID_TILES then
        table.insert(neighbors, { x = node.x, y = node.y - 1 })
--        if node.x + 1 <= GRID_TILES and not (grid[node.x + 1][node.y].building and grid[node.x][node.y - 1].building) then
--            table.insert(neighbors, { x = node.x + 1, y = node.y - 1 })
--        end
    end
    if node.y + 1 <= GRID_TILES then
        table.insert(neighbors, { x = node.x, y = node.y + 1 })
--        if node.x - 1 >= -GRID_TILES and not (grid[node.x - 1][node.y].building and grid[node.x][node.y + 1].building) then
--            table.insert(neighbors, { x = node.x - 1, y = node.y + 1 })
--        end
    end

--    if node.x - 1 >= -GRID_TILES then
--        table.insert(neighbors, { x = node.x - 1, y = node.y })
--        if node.y - 1 >= -GRID_TILES then
--            table.insert(neighbors, { x = node.x - 1, y = node.y - 1 })
--        end
--    end
--    if node.x + 1 <= GRID_TILES then
--        table.insert(neighbors, { x = node.x + 1, y = node.y })
--        if node.y + 1 <= GRID_TILES then
--            table.insert(neighbors, { x = node.x + 1, y = node.y + 1 })
--        end
--    end
--    if node.y - 1 >= -GRID_TILES then
--        table.insert(neighbors, { x = node.x, y = node.y - 1 })
--        if node.x + 1 <= GRID_TILES then
--            table.insert(neighbors, { x = node.x + 1, y = node.y - 1 })
--        end
--    end
--    if node.y + 1 <= GRID_TILES then
--        table.insert(neighbors, { x = node.x, y = node.y + 1 })
--        if node.x - 1 >= -GRID_TILES then
--            table.insert(neighbors, { x = node.x - 1, y = node.y + 1 })
--        end
--    end

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
                            if
                                not (k == 1 and l == 1 and grid[i + 1][j].building and grid[i][j + 1].building) and
                                not (k == -1 and l == 1 and grid[i - 1][j].building and grid[i][j + 1].building) and
                                not (k == -1 and l == -1 and grid[i - 1][j].building and grid[i][j - 1].building) and
                                not (k == 1 and l == -1 and grid[i + 1][j].building and grid[i][j - 1].building)
                            then
--                                local dirToTarget = toDeg(angle(i, j, x, y))
--                                local dirToOrigin = toDeg(angle(i, j, 0, 0))
--                                local improvement = grid[x][y].weight
                                local weight = grid[x][y].weight + dist(i, j, x, y) / 10
--                                local weight = grid[x][y].weight + grid[x][j].units / 2
--                                local weight = grid[x][y].weight + math.abs(angleDiff(dirToTarget, dirToOrigin)) / 1000
--                                local weight = grid[x][y].weight + math.abs(angleDiff(dirToTarget, dirToOrigin)) / 1000
--                                local weight = grid[x][y].weight + dist(x, y, 0, 0) / 100
    --                            love.window.showMessageBox("test", tostring(math.abs(angleDiff(dirToTarget, dirToOrigin))))
                                table.insert(options, {
                                    weight = weight,
                                    x = k,
                                    y = l
                                })
                            end
                        end
                    end
                end
            end

            table.sort(options, weightSort)

            grid[i][j].x = toWorldSpace(i)
            grid[i][j].y = toWorldSpace(j)

            local flow = {}
            for k = 1, #options do
                table.insert(flow, {
                    dir = angle(0, 0 , options[k].x, options[k].y),
                    nextTile = grid[i + options[k].x][j + options[k].y],
                })
            end

            grid[i][j].flow = flow
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
    SEARCH_NODES = {}

    for i = 1, #buildings do
        local building = buildings[i]
        if not building.isWall and not building.isTree and not building.isStone then
            for j = 0, #building.shape - 1 do
                local row = building.shape[j + 1]
                for i = 0, #row - 1 do
                    table.insert(SEARCH_NODES,
                        {
                            x = building.gridX + i,
                            y = building.gridY + j
                        }
                    )
                end
            end
        end
    end

    resetFields()

--    table.sort(options, weightSort)

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
    if MapManager.open then
        MapManager:scroll(y)
    else
        if y > 0 then
            targetScale = cam:getScale() + 0.3 * cam:getScale()
        elseif y < 0 then
            targetScale = cam:getScale() - 0.3 * cam:getScale()
        end

        targetScale = clamp(0.7, targetScale, 3)

        local mx, my = love.mouse.getPosition()
        local xDiff = love.graphics.getWidth() / 2 - mx
        local yDiff = love.graphics.getHeight() / 2 - my

        local currentX, currentY = cam:getPosition()
        targetCamX = currentX - (xDiff * sign(y) / 4) / cam:getScale()
        targetCamY = currentY - (yDiff * sign(y) / 4) / cam:getScale()
    end
end

function toGridSpace(pos)
    pos = pos / GRID_SIZE
    return clamp(-GRID_TILES, round(pos), GRID_TILES)
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
                local tile = grid[gridX + i][gridY + j]
                if tile.building or tile.units > 0 then
                    return true
                end
            else
               return true
            end
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end

    if key == "tab" then
        MapManager.open = not MapManager.open
    end

    if not MapManager.needsToChoose then
        if key == "space" then
            TimeManager.paused = not TimeManager.paused
        end

        if key == "right" then
            TimeManager.paused = false
            TimeManager.timeScale = TimeManager.timeScale + 1
            if TimeManager.timeScale > TimeManager.maxTimeScale then
                TimeManager.timeScale = TimeManager.maxTimeScale
            end
        end

        if key == "left" then
            TimeManager.timeScale = TimeManager.timeScale - 1
            if TimeManager.timeScale < 1 then
                TimeManager.timeScale = 0
                TimeManager.paused = true
            end
        end
    end

    if key == "lshift" then
        SHIFT_IS_DOWN = true
    end

    ---- Debug
    if key == "f1" then
        GRID_DEBUG = not GRID_DEBUG
    end

    if key == "f2" then
        STONE = 3000
        WOOD = 3000
        FOOD = 3000
        updateStorage()
    end

    if key == "f3" then
        DEBUG_MODE = not DEBUG_MODE
    end

    if key == "f4" then
        MapManager:generate()
    end
end

function love.keyreleased(key, scancode, isrepeat)
    if key == "lshift" then
        SHIFT_IS_DOWN = false
    end
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        MB1_CLICKED = true
    end

    if button == 2 then
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

function love.mousereleased(x, y, button, istouch)
    SELECT_ORIGIN_X = nil
end

function love.update(dt)
    local gameDt = TimeManager:update(dt)

    time = time + dt

    if GRID_DIRTY then
        GRID_DIRTY = false
        calculateGrid()
    end
    processField()

    local mx, my = love.mouse.getPosition()
    local worldMx, worldMy = cam:toWorld(mx, my)
    local gridX = toGridSpace(worldMx)
    local gridY = toGridSpace(worldMy)

    if SELECTED then
        SELECTED:update()
    end

    EnemyManager:update(gameDt)
    CloudManager:update(gameDt)
    PopulationManager:update(gameDt)
    MapManager:update()

    -- Border Pan
--    local xDiff = (love.graphics.getWidth() / 2 - mx) / love.graphics.getWidth()
--    local yDiff = (love.graphics.getHeight() / 2 - my) / love.graphics.getHeight()
--    local shouldPan = false
--
--    if
--        (mx < PAN_PADDING and my < love.graphics.getHeight() * 0.75) or mx > love.graphics.getWidth() - PAN_PADDING or
--        my < PAN_PADDING or (my > love.graphics.getHeight() - PAN_PADDING and
--        mx > love.graphics.getWidth() / 3)
--    then
--        shouldPan = true
--    end
--
--    if shouldPan then
--        local currentX, currentY = cam:getPosition()
--        targetCamX = currentX - (xDiff * PAN_SPEED * dt) / cam:getScale()
--        targetCamY = currentY - (yDiff * PAN_SPEED * dt) / cam:getScale()
--    end
--
    if updateFieldCount > UPDATE_FIELD_DURATION then
        updateFieldCount = 0
        calculateIntegrationField()
    else
        updateFieldCount = updateFieldCount + 1 * dt
    end

    local mouseDown = love.mouse.isDown(1)
    local aIsDown = love.keyboard.isDown("a")
    local dIsDown = love.keyboard.isDown("d")
    local wIsDown = love.keyboard.isDown("w")
    local sIsDown = love.keyboard.isDown("s")

    local currentX, currentY = cam:getPosition()

    if aIsDown then
        targetCamX = currentX - (PAN_SPEED * dt) / cam:getScale()
    end

    if dIsDown then
        targetCamX = currentX + (PAN_SPEED * dt) / cam:getScale()
    end

    if wIsDown then
        targetCamY = currentY - (PAN_SPEED * dt) / cam:getScale()
    end

    if sIsDown then
        targetCamY = currentY + (PAN_SPEED * dt) / cam:getScale()
    end

    if not MapManager.open then
        HOVERED_TILE = grid[gridX][gridY]


        if DEBUG_MODE then
            if mouseDown then
                local mx, my = love.mouse.getPosition()
                local worldMx, worldMy = cam:toWorld(mx, my)
    --             table.insert(enemyUnits, createZombie(worldMx + (math.random() - 0.5) * 80, worldMy + (math.random() - 0.5) * 80))
                table.insert(enemyUnits, Ogre.create(worldMx + (math.random() - 0.5) * 80, worldMy + (math.random() - 0.5) * 80))
            end
        end

        local windowBottom = love.graphics:getHeight()

        for i = #TABS, 1, -1 do
            TABS[i]:update(i * 150 - 130, windowBottom - 50)
        end

        CURRENT_BUTTONS = {}
        if SELECTED_TAB then
            CURRENT_BUTTONS = SELECTED_TAB.buttons
        end

        if #SELECTED_TILES > 0 then
            table.insert(CURRENT_BUTTONS, FORBID_BUTTON)
        end

        for i = #CURRENT_BUTTONS, 1, -1 do
            local button = CURRENT_BUTTONS[i]
            local x = (i - 1) * 100 + 60
            local y = windowBottom - 120
            local leftBound = x - button.width / 2
            local rightBound = x + button.width / 2
            local topBound = y - button.height / 2
            local bottomBound = y + button.height / 2

            local thisButtonHovered = button == HOVERED_BUTTON

            if
                mx < rightBound and mx > leftBound and
                my > topBound and my < bottomBound
            then
                if not thisButtonHovered then
                    HOVERED_BUTTON = button
                    if button.obj.cost and #button.obj.cost > 0 then
                        DescriptionPanel:setInfo(button.obj)
                        DescriptionPanel:setVisible(true)
                    end
                end
            elseif thisButtonHovered then
                HOVERED_BUTTON = nil
                DescriptionPanel:setVisible(false)
            end

            button:update(x, y, thisButtonHovered)
        end

        local mouseMovedTiles = false
        if gridX ~= HOVERED_GRID_X or gridY ~= HOVERED_GRID_Y then
            mouseMovedTiles = true

            HOVERED_GRID_X = gridX
            HOVERED_GRID_Y = gridY
        end

        if mouseDown then
            local mouseOverUi = false

            for i = 1, #CURRENT_BUTTONS do
                local button = CURRENT_BUTTONS[i]
                if button == HOVERED_BUTTON then
                    if MB1_CLICKED then
                        button:click(merge(SELECTED_TILES, SAVED_SELECTED_TILES))
                    end
                    mouseOverUi = true
                end
            end

            for i = 1, #TABS do
                local tab = TABS[i]
                if tab.hovered then
                    if MB1_CLICKED then
                        tab:click()
                    end
                    mouseOverUi = true
                end
            end

            if MB1_CLICKED then
                if not mouseOverUi and not SELECTED then
                    SELECTED_TAB = nil
                    SELECT_ORIGIN_X = worldMx
                    SELECT_ORIGIN_Y = worldMy

                    if SHIFT_IS_DOWN then
                        for i = #SELECTED_TILES, 1, -1 do
                            local tile = SELECTED_TILES[i]
                            if not contains(SAVED_SELECTED_TILES, tile) then
                                table.insert(SAVED_SELECTED_TILES, tile)
                            end
                        end
                    else
                        for i = 1, #SAVED_SELECTED_TILES do
                            SAVED_SELECTED_TILES[i].building.highlighted = nil
                        end
                        for i = 1, #SELECTED_TILES do
                            SELECTED_TILES[i].building.highlighted = nil
                        end

                        SAVED_SELECTED_TILES = {}
                    end

                    SELECTED_TILES = {}

                    if HOVERED_TILE.building then
                        if SHIFT_IS_DOWN and HOVERED_TILE.building.highlighted then
                            for i = #SAVED_SELECTED_TILES, 1, -1 do
                                local tile = SAVED_SELECTED_TILES[i]
                                if tile == HOVERED_TILE then
                                    table.remove(SAVED_SELECTED_TILES, i)
                                    tile.building.highlighted = nil
                                end
                            end

                            if #SAVED_SELECTED_TILES == 1 then
                                local tile = SAVED_SELECTED_TILES[1]
                                tile.building.highlighted = 2
                                DescriptionPanel:setVisible(true)
                                DescriptionPanel:setInfo(tile.building)
                            else
                                DescriptionPanel:setVisible(false)
                            end
                        else
                            table.insert(SELECTED_TILES, HOVERED_TILE)

                            if #SELECTED_TILES == 1 and #SAVED_SELECTED_TILES == 0 then
                                HOVERED_TILE.building.highlighted = 2
                                DescriptionPanel:setVisible(true)
                                DescriptionPanel:setInfo(HOVERED_TILE.building)
                            else
                                HOVERED_TILE.building.highlighted = 1
                                DescriptionPanel:setVisible(false)
                            end
                        end
                    else
                        DescriptionPanel:setVisible(false)
                    end
                else
                    for i = 1, #SAVED_SELECTED_TILES do
                        SAVED_SELECTED_TILES[i].building.highlighted = nil
                    end
                    for i = 1, #SELECTED_TILES do
                        SELECTED_TILES[i].building.highlighted = nil
                    end

                    SAVED_SELECTED_TILES = {}
                    SELECTED_TILES = {}
                end
            end


            if SELECTED then
                if (mouseMovedTiles or MB1_CLICKED) and not mouseOverUi then
                    SELECTED:click()
                end
            elseif SELECT_ORIGIN_X then
                SELECT_END_X = worldMx
                SELECT_END_Y = worldMy

                if mouseMovedTiles then
                    local originGridX = toGridSpace(SELECT_ORIGIN_X)
                    local originGridY = toGridSpace(SELECT_ORIGIN_Y)

                    for i = 1, #SELECTED_TILES do
                        SELECTED_TILES[i].building.highlighted = nil
                    end
                    SELECTED_TILES = {}

                    local loopStartX = math.min(gridX, originGridX)
                    local loopEndX = math.max(gridX, originGridX)
                    local loopStartY = math.min(gridY, originGridY)
                    local loopEndY = math.max(gridY, originGridY)

                    for i = loopStartX, loopEndX do
                        for j = loopStartY, loopEndY do
                            local tile = grid[i][j]
                            if tile.building then
                                tile.building.highlighted = 1
                                table.insert(SELECTED_TILES, tile)
                            end
                        end
                    end
                end
            end
        end
    end


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

    for i = #enemyUnits, 1, -1 do
        local shouldDelete = enemyUnits[i]:update(gameDt, i)

        if shouldDelete then
            table.remove(enemyUnits, i)
        end

--        local e1 = enemyUnits[i]
--        for j = #enemyUnits, 1, -1 do
--            if j ~= i then
--                local e2 = enemyUnits[j]
--                local distance = dist(e1.x, e1.y, e2.x, e2.y)
--
--                if distance < 128 then
--                    local dir = angle(e1.x, e1.y, e2.x, e2.y)
--                    e1.x = e1.x - lengthDirX(800 * gameDt / (distance + 64), dir)
--                    e1.y = e1.y - lengthDirY(800 * gameDt / (distance + 64), dir)
--                end
--            end
--        end
    end

    love.graphics.setCanvas(DEBRIS_CANVAS)
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        local shouldDelete = bullet:update(gameDt)
        if shouldDelete then
            if bullet.ammo.hitImage and not bullet.isHit then
                love.graphics.draw(bullet.ammo.hitImage,
                    bullet.x + GRID_SIZE * GRID_TILES,
                    bullet.y + GRID_SIZE * GRID_TILES,
                    bullet.angle, bullet.scale / DEBRIS_CANVAS_SCALE, bullet.scale / DEBRIS_CANVAS_SCALE,
                    bullet.originX, bullet.originY)
            end

            table.remove(bullets, i)
        end
    end
    love.graphics.setCanvas()

    for i = #explosions, 1, -1 do
        local shouldDelete = explosions[i]:update(gameDt)
        if shouldDelete then
            table.remove(explosions, i)
        end
    end

    for i = #buildings, 1, -1 do
        local shouldDelete = buildings[i]:update(gameDt)
        if shouldDelete then
            table.remove(buildings, i)
        end
    end

    local scale = lerp(cam:getScale(), targetScale, 0.05)
    cam:setScale(scale)

    local currentX, currentY = cam:getPosition()

    local camX = lerp(currentX, targetCamX, 0.05)
    local camY = lerp(currentY, targetCamY, 0.05)
    cam:setPosition(camX, camY)

--    hud[2] = "Happiness: "..tostring(HAPPINESS).."/"..tostring(MAX_HAPPINESS)
    hud[1] = "Population: "..tostring(POPULATION)
    hud[2] = "Wood: "..tostring(WOOD)
    hud[3] = "Food: "..tostring(FOOD)
    hud[4] = "Stone: "..tostring(STONE)

    debug[1] = "Current FPS: "..tostring(love.timer.getFPS())
    debug[2] = "enemies: "..tostring(#enemyUnits)
    debug[3] = "explosions: "..tostring(#explosions)
    debug[4] = "buildings: "..tostring(#buildings)
    debug[5] = "bullets: "..tostring(#bullets)
    debug[6] = "target scale: "..tostring(targetScale)

    MB1_CLICKED = false
end

local function drawCameraStuff(l,t,w,h)
    love.graphics.draw(GRASS_CANVAS,
        -GRID_SIZE * (GRID_TILES + 0.5) - GRASS_PADDING_TILES * GRASS_TILE_SIZE * GRASS_SCALE,
        -GRID_SIZE * (GRID_TILES + 0.5) - GRASS_PADDING_TILES * GRASS_TILE_SIZE * GRASS_SCALE,
        0, GRASS_SCALE, GRASS_SCALE)

    love.graphics.draw(DEBRIS_CANVAS,
        -GRID_SIZE * GRID_TILES,
        -GRID_SIZE * GRID_TILES,
        0, DEBRIS_CANVAS_SCALE, DEBRIS_CANVAS_SCALE)

    -- Draw grid

    if SELECTED then
        local scale = math.min(cam:getScale() / 2 - 0.1, 0.25)
        love.graphics.setColor(1, 1, 1, scale)
        love.graphics.draw(gridcanvas, -GRID_SIZE * (GRID_TILES + 0.5), -GRID_SIZE * (GRID_TILES + 0.5), 0, GRID_SCALE, GRID_SCALE, 0, 0)
        love.graphics.setColor(1, 1, 1, 1)
    end

    love.graphics.setShader(DropShadowShader)
    for i = #buildings, 1, -1 do
        buildings[i]:drawShadow()
    end
    love.graphics.setShader()

    for i = #buildings, 1, -1 do
        buildings[i]:draw()
    end

    for i = 1, #enemyUnits, 1 do
        enemyUnits[i]:draw()
    end
--    love.graphics.draw(SPRITE_BATCH)

    for i = 1,#bullets,1 do
        bullets[i]:draw()
    end

    for i = 1, #buildings, 1 do
        buildings[i]:postDraw()
    end

    love.graphics.setBlendMode("add")
    for i = 1,#explosions,1 do
        explosions[i]:draw()
    end
    love.graphics.setBlendMode("alpha")

    if SELECTED then
        SELECTED:draw()
    end

    if SELECT_ORIGIN_X and SELECT_END_X then
        love.graphics.setColor(1, 1, 1, 0.2)
        love.graphics.rectangle("fill", SELECT_ORIGIN_X, SELECT_ORIGIN_Y, SELECT_END_X - SELECT_ORIGIN_X, SELECT_END_Y - SELECT_ORIGIN_Y)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", SELECT_ORIGIN_X, SELECT_ORIGIN_Y, SELECT_END_X - SELECT_ORIGIN_X, SELECT_END_Y - SELECT_ORIGIN_Y)
    end

--     Grid debug
    if GRID_DEBUG then
        for i = -GRID_TILES, GRID_TILES, 1 do
            for j = -GRID_TILES, GRID_TILES, 1 do
--                local value = grid[i][j].weight
--                love.graphics.print(tostring(roundDecimal(value, 2)), i * GRID_SIZE, j * GRID_SIZE)
    --            local value = grid[i][j].building
    --            love.graphics.print(tostring(value), i * GRID_SIZE, j * GRID_SIZE)

    --            local value = grid[i][j].noise
    --            love.graphics.setColor(value, value, value, 0.2)
    --            love.graphics.rectangle('fill',i * GRID_SIZE, j * GRID_SIZE, 64, 64)

                local flow = grid[i][j].flow
                if flow[1].x == 0 and flow[1].y == 0 then
                    love.graphics.circle("fill", i * GRID_SIZE, j * GRID_SIZE, 2, 8)
                else
    --                love.graphics.line(i * GRID_SIZE, j * GRID_SIZE, (i + flow.x / 3) * GRID_SIZE, (j + flow.y / 3) * GRID_SIZE)
                    love.graphics.line(i * GRID_SIZE, j * GRID_SIZE, (i * GRID_SIZE + flow[1].nextTile.x) / 2, (flow[1].nextTile.y + j * GRID_SIZE) / 2)
                end
            end
        end
    end

    local currentX, currentY = cam:getPosition()
    CloudManager:draw(currentX, currentY)

--    love.graphics.setShader(FOW_SHADER) --draw something here
--    love.graphics.draw(SHADOW_IMAGE, -SHADOW_SIZE / 2, -SHADOW_SIZE / 2, 0, SHADOW_SIZE, SHADOW_SIZE)
--    love.graphics.setShader()
end

function love.draw()
    cam:draw(drawCameraStuff)

    TimeManager:draw()
    DescriptionPanel:draw()
    MapManager:draw()

    if not MapManager.open then
        for i = 1, #TABS do
            TABS[i]:draw()
        end
    end

    for i = 1, #CURRENT_BUTTONS do
        CURRENT_BUTTONS[i]:draw()
    end

    for i = 1, #hud, 1 do
        love.graphics.print(hud[i], 20, 30 + (i - 1) * 24)
    end

    for i = 1, #debug, 1 do
        love.graphics.print(debug[i], love.graphics.getWidth() - 200, 60 + i * 20)
    end
end

function getClosest(x, y, targets, fuzziness, filter)
    local lowestRange = 99999
    local closest

    for i = 1, #targets, 1 do
        local target = targets[i]
        local offsetX = 0
        local offsetY = 0
        local isValid = target.health > 0

        if fuzziness and fuzziness > 0 then
            offsetX = (math.random() - 0.5) * fuzziness
            offsetY = (math.random() - 0.5) * fuzziness
        end

        if filter then
            isValid = filter(target)
        end

        if isValid then
            local dist = dist(x, y, target.x + offsetX, target.y + offsetY)
            if dist < lowestRange then
                lowestRange = dist
                closest = target

            end
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

function contains(table, value)
    for i = 1, #table do
        if table[i] == value then
            return true
        end
    end

    return false
end