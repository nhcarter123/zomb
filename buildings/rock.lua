return {
    getTitle = function()
        return "Rock"
    end,

    getDescription = function()
        return "A giant boulder"
    end,

    create = function(self, gridX, gridY)
        local image = ROCK_4_IMAGE
        local rand = math.random()

        if rand > 0.8 then
            image = ROCK_5_IMAGE
        elseif rand > 0.5 then
            image = ROCK_6_IMAGE
        elseif rand > 0.3 then
            image = ROCK_7_IMAGE
        end

        local building = Building.create(gridX, gridY, 0, 0, image)

        building.title = self:getTitle()
        building.description = self:getDescription()
        building.isRock = true
--        building.angle = toRad(math.random() * 360)
        --    building.scale = 1
        --    building.scale = 0.16 + math.random() * 0.02
--        building.scale = 0.42 + math.random() * 0.15
        building.scale = 0.38 + math.random() * 0.08
        building:setGrid()

        return building
    end
}