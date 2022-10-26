return {
    create = function(x, y)
        local unit = createZombie(x, y)

        unit.image = OGRE_IMAGE
        unit.originX = unit.image:getWidth() / 2
        unit.originY = unit.image:getHeight() / 2
        unit.timeScale = 0.6
        unit.health = 800
        unit.maxHealth = 800
        unit.size = 3
        unit.damage = 16

        return unit
    end
}