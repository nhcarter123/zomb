return {
    getTitle = function()
        return "Tree"
    end,

    getDescription = function()
        return "A large oak tree"
    end,

    create = function(self, gridX, gridY)
        local image = TREE_1_IMAGE
        local rand = math.random()

        if rand > 0.7 then
            image = TREE_2_IMAGE
        elseif rand > 0.4 then
            image = TREE_3_IMAGE
        end

        local building = Building.create(gridX, gridY, 0, 0, image)

        building.title = self:getTitle()
        building.description = self:getDescription()
        building.isTree = true
--        building.angle = toRad(math.random() * 360)
        --    building.scale = 1
        --    building.scale = 0.16 + math.random() * 0.02
--        building.scale = 0.42 + math.random() * 0.15
        building.scale = 0.32 + math.random() * 0.08
        building:setGrid()


        local parentDraw = building.draw

--        building.draw = function(self)
--            love.graphics.setColor(0, 0, 0, 0.3)
--            love.graphics.draw(self.image, self.x + 20, self.y + 20, self.angle, self.scale, self.scale, self.originX, self.originY)
--            love.graphics.setColor(1, 1, 1, 1)
--
--            parentDraw(self)
--        end

--        building.stumpImage = STUMP_IMAGE
--        building.stumpHalfWidth = building.stumpImage:getWidth() / 2
--        building.stumpHalfHeight = building.stumpImage:getHeight() / 2

        return building
    end
}