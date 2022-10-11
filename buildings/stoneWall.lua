return {
    create = function(gridX, gridY)
        local building = WoodWall.create(gridX, gridY)

        building.title = "Stone wall"
        building.description =  "Walls made of stacked stone"
        building.health = 200
        building.maxHealth = 200
        building.cost = {{ "Stone", 1 } }
        building.material = "Stone"
        building.image = STONE_WALL_1_IMAGE

        return building
    end
}

