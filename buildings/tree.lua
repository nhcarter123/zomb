function createTree(gridX, gridY)
--    local image = TREE_
    local image = TREE_4_IMAGE

    if math.random() > 0.5 then
        image = TREE_5_IMAGE
    end
--
--    if math.random() > 0.6 then
--        image = TREE_3_IMAGE
--    end


    local building = createBuilding(gridX, gridY, 0, 0, image)

    building.isTree = true
    building.stumpImage = STUMP_IMAGE
    building.stumpHalfWidth = building.stumpImage:getWidth() / 2
    building.stumpHalfHeight = building.stumpImage:getHeight() / 2
    building.angle = toRad(math.random() * 360)
--    building.scale = 1
--    building.scale = 0.16 + math.random() * 0.02
    building.scale = 0.42 + math.random() * 0.15
    building:setGrid()

    building.draw = function(self)
        if self.beingCut then
            love.graphics.draw(self.stumpImage, self.x, self.y, self.angle, self.scale, self.scale, self.stumpHalfWidth, self.stumpHalfHeight)
            love.graphics.setColor(1, 1, 1, 0.5)
            love.graphics.draw(self.image, self.x, self.y, self.angle, self.scale, self.scale, self.originX, self.originY)
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.draw(self.image, self.x, self.y, self.angle, self.scale, self.scale, self.originX, self.originY)
        end
    end

    return building
end