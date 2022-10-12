return {
    createWoodWallButton = function()
        local wall = WoodWall.create(0, 0)
        local button = createButton(wall)

        button.click = function(self)
            SELECTED = Selected.create(WoodWall.create, wall.cost)
        end

        return button
    end,

    createStoneWallButton = function()
        local wall = StoneWall.create(0, 0)
        local button = createButton(wall)

        button.click = function(self)
            SELECTED = Selected.create(StoneWall.create, wall.cost)
        end

        return button
    end,

    createOutpostButton = function()
        local tower = Tower.create(0, 0)
        local button = createButton(tower)

        button.baseScale = 0.5

        button.click = function(self)
            SELECTED = Selected.create(Tower.create, tower.cost)
        end

        return button
    end,

    createCatapultTowerButton = function()
        local tower = CatapultTower.create(0, 0)
        local button = createButton(tower)

        button.baseScale = 0.5

        button.click = function(self)
            SELECTED = Selected.create(CatapultTower.create, tower.cost)
        end

        return button
    end,

    createFarmButton = function()
        local farm = Farm.create(0, 0)
        local button = createButton(farm)

        button.baseScale = 0.25
        button.click = function(self)
            SELECTED = Selected.create(Farm.create, farm.cost)
        end

        return button
    end,

    createStorageButton = function()
        local storage = Storage.create(0, 0)
        local button = createButton(storage)

        button.baseScale = 0.25

        button.click = function(self)
            SELECTED = Selected.create(Storage.create, storage.cost)
        end

        return button
    end,

    createHouseButton = function()
        local house = House.create(0, 0)
        local button = createButton(house)

        button.baseScale = 0.25
        button.click = function(self)
            SELECTED = Selected.create(House.create, house.cost)
        end

        return button
    end,

    createWoodCutterHutButton = function()
        local woodCutterHut = WoodCutterHut.create(0, 0)
        local button = createButton(woodCutterHut)

        button.baseScale = 0.5
        button.click = function(self)
            SELECTED = Selected.create(WoodCutterHut.create, woodCutterHut.cost)
        end

        return button
    end,

    createMiningCampButton = function()
        local miningCamp = MiningCamp.create(0, 0)
        local button = createButton(miningCamp)

        button.baseScale = 0.5
        button.click = function(self)
            SELECTED = Selected.create(MiningCamp.create, miningCamp.cost)
        end

        return button
    end,

    createForbidButton = function()
        local button = createButton({
            image = REMOVE_IMAGE
        }, {})

        button.baseScale = 0.5
        button.click = function(self, tiles)
            local allForbid = true
            for i = 1, #tiles do
                if not tiles[i].building.forbid then
                    allForbid = false
                end
            end
            for i = 1, #tiles do
                tiles[i].building.forbid = not allForbid
            end

            setWorkers()
        end

        return button
    end,
}
