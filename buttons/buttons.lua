return {
    createWoodWallButton = function()
        local obj = WoodWall.create(0, 0)
        local button = createButton(obj)

        button.click = function(self)
            SELECTED = Selected.create(WoodWall.create, obj.cost)
        end

        return button
    end,

    createStoneWallButton = function()
        local obj = StoneWall.create(0, 0)
        local button = createButton(obj)

        button.click = function(self)
            SELECTED = Selected.create(StoneWall.create, obj.cost)
        end

        return button
    end,

    createOutpostButton = function()
        local obj = Tower.create(0, 0)
        local button = createButton(obj)

        button.baseScale = 0.5

        button.click = function(self)
            SELECTED = Selected.create(Tower.create, obj.cost)
        end

        return button
    end,

    createCatapultTowerButton = function()
        local obj = CatapultTower.create(0, 0)
        local button = createButton(obj)

        button.baseScale = 0.5

        button.click = function(self)
            SELECTED = Selected.create(CatapultTower.create, obj.cost)
        end

        return button
    end,

    createFarmButton = function()
        local obj = Farm.create(0, 0)
        local button = createButton(obj)

        button.baseScale = 0.25
        button.click = function(self)
            SELECTED = Selected.create(Farm.create, obj.cost)
        end

        return button
    end,

    createStorageButton = function()
        local obj = Storage.create(0, 0)
        local button = createButton(obj)

        button.baseScale = 0.25

        button.click = function(self)
            SELECTED = Selected.create(Storage.create, obj.cost)
        end

        return button
    end,

    createHouseButton = function()
        local obj = House.create(0, 0)
        local button = createButton(obj)

        button.baseScale = 0.25
        button.click = function(self)
            SELECTED = Selected.create(House.create, obj.cost)
        end

        return button
    end,

    createStoneHouseButton = function()
        local obj = StoneHouse.create(0, 0)
        local button = createButton(obj)

        button.baseScale = 0.25 * (2 / 3)
        button.click = function(self)
            SELECTED = Selected.create(StoneHouse.create, obj.cost)
        end

        return button
    end,

    createWoodCutterHutButton = function()
        local obj = WoodCutterHut.create(0, 0)
        local button = createButton(obj)

        button.baseScale = 0.5
        button.click = function(self)
            SELECTED = Selected.create(WoodCutterHut.create, obj.cost)
        end

        return button
    end,

    createMiningCampButton = function()
        local obj = MiningCamp.create(0, 0)
        local button = createButton(obj)

        button.baseScale = 0.5
        button.click = function(self)
            SELECTED = Selected.create(MiningCamp.create, obj.cost)
        end

        return button
    end,

    createMillButton = function()
        local obj = Mill.create(0, 0)
        local button = createButton(obj)

        button.baseScale = 0.25
        button.click = function(self)
            SELECTED = Selected.create(Mill.create, obj.cost)
        end

        return button
    end,

    createSawmillButton = function()
        local obj = Sawmill.create(0, 0)
        local button = createButton(obj)

        button.baseScale = 0.25
        button.click = function(self)
            SELECTED = Selected.create(Sawmill.create, obj.cost)
        end

        return button
    end,

    createForbidButton = function()
        local button = createButton({
            image = REMOVE_ICON_IMAGE
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
