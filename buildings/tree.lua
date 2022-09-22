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

    building.angle = toRad(math.random() * 360)
--    building.scale = 1
--    building.scale = 0.16 + math.random() * 0.02
    building.scale = 0.42 + math.random() * 0.15
    building:setGrid()

    return building
end