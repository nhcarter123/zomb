local width = 1000
local height = 800
local nodeSpacingX = 220
local nodeSpacingY = nodeSpacingX * 1
local length = 15
local mapHeight = nodeSpacingY * length
local scrollPadding = 250

local getNodeMetadata = function(type)
    local offset = 32

    if type == "Start" then
       return {
           image = HOME_ICON_IMAGE,
           offset = offset,
       }
    end

    if type == "Event" then
        return {
            image = QUESTION_MARK_ICON_IMAGE,
            offset = offset,
        }
    end

    if type == "Boss" then
        return {
            image = BOSS_ICON_IMAGE,
            offset = 50,
        }
    end

    if type == "Enemy" then
        return {
            image = ENEMY_ICON_IMAGE,
            offset = offset,
        }
    end

    if type == "Wood" then
        return {
            image = WOOD_ICON_IMAGE,
            offset = offset,
        }
    end

    if type == "Food" then
        return {
            image = BREAD_ICON_IMAGE,
            offset = offset,
        }
    end

    if type == "Stone" then
        return {
            image = STONES_ICON_IMAGE,
            offset = offset,
        }
    end

    if type == "Treasure" then
        return {
            image = TREASURE_ICON_IMAGE,
            offset = offset,
        }
    end

    love.window.showMessageBox("test", tostring(type))
end

local createNode = function(type, x, y)
    return {
        x = x,
        y = y,
        type = type,
        visited = false,
        nextNodes = {},
        children = 0,
    }
end

local isTreasureIndex = function(len, n)
    return n == math.ceil(len / 3) or n == math.ceil(2 * len / 3)
end

return {
    open = true,
    nodes = {},
    length = length,
    camera = Gamera.new(-width / 2, -height / 2, width, mapHeight * 2),
    scrollY = scrollPadding,
    scrollPadding = scrollPadding,
    currentRow = 1,
    currentNode = 1,
    currentPath = 1,

    generate = function(self)
        local centerX = love.graphics.getWidth() / 2
        local centerY = love.graphics.getHeight() / 2
        self.camera:setWindow(centerX - width / 2, centerY - height / 2, width, height)
        self.camera:setPosition(0, self.scrollY)

        local currentNodeScore = 0
        local lastNodesCount = 1
        local type = "Start"

        for i = 1, self.length do
            local y = mapHeight - (i - 0.5) * nodeSpacingY

            if i == 1 then
                local startNode = createNode(type, 0, y)
                startNode.visited = true
                self.nodes[i] = { startNode }
            else
                local previousNodes = self.nodes[i - 1]
                local nodes = {}
                local nodesCount = lastNodesCount
                local targetNodesCount = 3

                if i > self.length - 3 then
                    targetNodesCount = 1
                end

                local rand = math.random()
                if math.random() > 0.75 then
                    targetNodesCount = targetNodesCount + 1
                elseif math.random() > 0.5 then
                    targetNodesCount = targetNodesCount - 1
                end

                nodesCount = clamp(1, nodesCount + clamp(-1, targetNodesCount - nodesCount, 1), 10)

                if i == self.length then
                    nodesCount = 1
                end

                local totalWidth = (nodesCount - 1) * nodeSpacingX

                for j = 1, nodesCount do
                    local x = (j - 1) * nodeSpacingX - totalWidth / 2
                    local offsetX = (math.random() - 0.5) * nodeSpacingX * 0.7
                    local offsetY = (math.random() - 0.5) * nodeSpacingY * 0.7

                    if i == self.length then
                        offsetX = 0
                        offsetY = 0
                        type = "Boss"
                    elseif isTreasureIndex(self.length, i) then
                        type = "Treasure"
                    elseif isTreasureIndex(self.length, i + 1) then
                        type = "Enemy"
                    else
                        local rand = math.random()
                        if rand > 0.7 then
                            type = "Event"
                        elseif rand > 0.55 then
                            type = "Enemy"
                        elseif rand > 0.15 then
                            type = "Wood"
                        elseif rand > 0.1 then
                            type = "Food"
                        else
                            type = "Stone"
                        end
                    end

                    local newNode = createNode(type, x + offsetX, y + offsetY)
                    table.insert(nodes, newNode)
                end

                for j = 1, nodesCount do
                    local node = nodes[j]
                    for k = 1, #previousNodes do
                        if
                            k == j or
                            (nodesCount < lastNodesCount and k - 1 == j) or
                            (nodesCount > lastNodesCount and k + 1 == j)
                        then
                            local previousNode = previousNodes[k]
                            table.insert(previousNode.nextNodes, node)
                            node.children = node.children + 1
                        end
                    end
                end

                ---- Prune some children to make the map more interesting
                local pruneChance = 0.25
                for j = 1, nodesCount do
                    local node = nodes[j]

                    -- Prune in random direction
                    local loopStart = 1
                    local loopEnd = #previousNodes
                    local loopDir = 1

                    if math.random() > 0.5 then
                        loopStart = #previousNodes
                        loopEnd = 1
                        loopDir = -1
                    end

                    for k = loopStart, loopEnd, loopDir do
                        local previousNode = previousNodes[k]
                        for l = #previousNode.nextNodes, 1, -1 do
                            local nextNode = previousNode.nextNodes[l]
                            if #previousNode.nextNodes > 1 and nextNode == node and node.children > 1 and math.random() < pruneChance then
                                table.remove(previousNode.nextNodes, l)
                                node.children = node.children - 1
                            end
                        end
                    end
                end

                self.nodes[i] = nodes
                lastNodesCount = nodesCount
            end
        end
    end,

    scroll = function(self, y)
        self.scrollY = clamp(self.scrollPadding, self.scrollY - y * 40, mapHeight - self.scrollPadding)
    end,

    update = function(self)
        local currentX, currentY = self.camera:getPosition()
        local y = lerp(currentY, self.scrollY, 0.05)
        self.camera:setPosition(0, y)
    end,

    draw = function(self)
        if self.open then
            local centerX = love.graphics.getWidth() / 2
            local centerY = love.graphics.getHeight() / 2
            local borderSize = 4
            local linePadding = 1

            love.graphics.setColor(0.1, 0.1, 0.1)
            love.graphics.rectangle("fill", centerX - width / 2 - borderSize, centerY - height / 2 - borderSize, width + borderSize * 2, height + borderSize * 2)
            love.graphics.setColor(0.8, 0.8, 0.6)
            love.graphics.rectangle("fill", centerX -width / 2, centerY - height / 2, width, height)
            love.graphics.setColor(1, 1, 1)

            self.camera:draw(
                function(l, t, w, h)
                    ---- TODO some/most of this can probably get turned into a canvas to improve performance

                    for i = 1, self.length do
                        local y =  mapHeight - (i - 1) * nodeSpacingY
                        love.graphics.setColor(0.7, 0.7, 0.5)
                        love.graphics.line(-width / 2 + 20, y, width / 2 - 80, y)
                        love.graphics.setColor(0, 0, 0)
                        love.graphics.print("Day"..tostring(i), width / 2 - 60, y - 8)
                    end

--                    love.graphics.circle("fill", 50, mapHeight - (0.5) * nodeSpacingY - (24 * (TimeManager.day - 1) + (TimeManager.time - TimeManager.startTime)) * nodeSpacingY / 24, 10)

                    local progressX = 0
                    local progressY = 0

                    for i = 1, #self.nodes do
                        local nodes = self.nodes[i]
                        for j = 1, #nodes do
                            local node = nodes[j]
                            local data = getNodeMetadata(node.type)

                            for k = 1, #node.nextNodes do
                                local nextNode = node.nextNodes[k]
                                local nextNodeData = getNodeMetadata(nextNode.type)
                                local dir = angle(node.x, node.y, nextNode.x, nextNode.y)
                                local offsetX1 = lengthDirX(linePadding * data.offset, dir)
                                local offsetY1 = lengthDirY(linePadding * data.offset, dir)
                                local offsetX2 = lengthDirX(linePadding * nextNodeData.offset, dir)
                                local offsetY2 = lengthDirY(linePadding * nextNodeData.offset, dir)

                                local lineX1 = node.x + offsetX1
                                local lineY1 = node.y + offsetY1
                                local lineX2 = nextNode.x - offsetX2
                                local lineY2 = nextNode.y - offsetY2

                                if node.visited and nextNode.visited then
                                    love.graphics.setLineWidth(5)
                                    love.graphics.setColor(0, 0, 0)
                                else
                                    love.graphics.setLineWidth(4)
                                    love.graphics.setColor(0.6, 0.6, 0.4)
                                end

                                love.graphics.line(lineX1, lineY1, lineX2, lineY2)

                                if self.currentRow == i and self.currentNode == j and self.currentPath == k then
                                    local height = mapHeight - (0.5) * nodeSpacingY - (24 * (TimeManager.day - 1) + (TimeManager.time - TimeManager.startTime)) * nodeSpacingY / 24
                                    local pct = (height - node.y) / (nextNode.y - node.y)

                                    if pct >= 1 then
                                        self.currentRow = self.currentRow + 1
                                        nextNode.visited = true
                                    end

                                    progressX = lineX1 * (1 - pct) + lineX2 * pct
                                    progressY = lineY1 * (1 - pct) + lineY2 * pct

                                    love.graphics.setLineWidth(5)
                                    love.graphics.setColor(0, 0, 0)
                                    love.graphics.line(lineX1, lineY1, progressX, progressY)
                                end
                            end
                            love.graphics.setColor(1, 1, 1)
                            love.graphics.draw(data.image, node.x, node.y, 0, 0.7, 0.7, data.offset, data.offset)
                        end
                    end

                    love.graphics.setColor(0, 0, 0)
                    love.graphics.circle("fill", progressX, progressY, 10)
                end
            )

            love.graphics.setLineWidth(1)
        end
    end
}
