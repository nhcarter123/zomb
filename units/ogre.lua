return {
    create = function(x, y)
        local unit = createZombie(x, y)

        unit.image = OGRE_IMAGE
        unit.timeScale = 0.5
        unit.health = 400
        unit.maxHealth = 400

        return unit
    end
}