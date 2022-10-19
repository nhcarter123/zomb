local width = 1000
local height = 800
local nodeSpacingX = 220
local nodeSpacingY = nodeSpacingX * 1
local length = 16
local mapHeight = nodeSpacingY * length
local scrollPadding = 250

local createNode = function(type, x, y)
    return {
        x = x + (math.random() - 0.5) * 120,
        y = y + (math.random() - 0.5) * 120,
        type = type,
        image = QUESTION_MARK_IMAGE,
        visited = true,
        nextNodes = {},
        children = 0,
    }
end

return {
    open = true,
    nodes = {},
    length = length,
    camera = Gamera.new(-width / 2, -height / 2, width, mapHeight * 2),
    scrollY = scrollPadding,
    scrollPadding = scrollPadding,

    generate = function(self)
        local centerX = love.graphics.getWidth() / 2
        local centerY = love.graphics.getHeight() / 2
        self.camera:setWindow(centerX - width / 2, centerY - height / 2, width, height)
        self.camera:setPosition(0, self.scrollY)

        local currentNodeScore = 0
        local lastNodesCount = 1

        for i = 1, self.length do
            local y = mapHeight - (i - 0.5) * nodeSpacingY

            if i == 1 then
                self.nodes[i] = { createNode("Start", 0, y) }
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
                    local newNode = createNode("Start", x, y)
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
                local pruneChance = 0.3
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

            love.graphics.setColor(0.1, 0.1, 0.1)
            love.graphics.rectangle("fill", centerX - width / 2 - borderSize, centerY - height / 2 - borderSize, width + borderSize * 2, height + borderSize * 2)
            love.graphics.setColor(0.8, 0.8, 0.6)
            love.graphics.rectangle("fill", centerX - width / 2, centerY - height / 2, width, height)
            love.graphics.setColor(1, 1, 1)

            self.camera:draw(
                function(l, t, w, h)
                    for i = 1, #self.nodes do
                        local nodes = self.nodes[i]
                        for j = 1, #nodes do
                            local node = nodes[j]

                            for k = 1, #node.nextNodes do
                                local nextNode = node.nextNodes[k]
                                love.graphics.line(node.x, node.y, nextNode.x, nextNode.y)
                            end

                            love.graphics.draw(node.image, node.x, node.y, 0, 0.2, 0.2, 120, 120)
                        end
                    end
                end
            )
        end
    end
}
