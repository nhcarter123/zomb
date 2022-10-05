return {
    create = function(gridX, gridY)
        local image = TREE_1_IMAGE
        local rand = math.random()

        if rand > 0.7 then
            image = TREE_2_IMAGE
        elseif rand > 0.4 then
            image = TREE_3_IMAGE
        end

        local building = Building.create(gridX, gridY, 0, 0, image)

        building.title = "Tree"
        building.description = "A large oak tree"
        building.isTree = true
        building.wood = 100
--        building.angle = toRad(math.random() * 360)
        --    building.scale = 1
        --    building.scale = 0.16 + math.random() * 0.02
--        building.scale = 0.42 + math.random() * 0.15
        building.scale = 0.32 + math.random() * 0.08

        return building
    end
}