return {
    createWallButton = function()
        local wall = Wall.create(0, 0)
        local cost =  {{ "Wood", 1 }}
        local button = createButton(wall, cost)

        button.click = function(self)
            SELECTED = Selected.create(Wall.create, cost)
        end

        return button
    end,

    createOutpostButton = function()
        local tower = Tower.create(0, 0)
        local cost =  {{ "Wood", 6 }}
        local button = createButton(tower, cost)

        button.baseScale = 0.5

        button.click = function(self)
            SELECTED = Selected.create(Tower.create, cost)
        end

        return button
    end,

    createFarmButton = function()
        local farm = Farm.create(0, 0)
        local cost =  {{ "Wood", 5 }}
        local button = createButton(farm, cost)

        button.baseScale = 0.25
        button.click = function(self)
            SELECTED = Selected.create(Farm.create, cost)
        end

        return button
    end,

    createStorageButton = function()
        local storage = Storage.create(0, 0)
        local cost =  {{ "Wood", 15 }}
        local button = createButton(storage, cost)

        button.baseScale = 0.25

        button.click = function(self)
            SELECTED = Selected.create(Storage.create, cost)
        end

        return button
    end,

    createHouseButton = function()
        local house = House.create(0, 0)
        local cost =  {{ "Wood", 5 }}
        local button = createButton(house, cost)

        button.baseScale = 0.25
        button.click = function(self)
            SELECTED = Selected.create(House.create, cost)
        end

        return button
    end,

    createWoodCutterHutButton = function()
        local woodCutterHut = WoodCutterHut.create(0, 0)
        local cost =  {{ "Wood", 5 }}
        local button = createButton(woodCutterHut, cost)

        button.baseScale = 0.5
        button.click = function(self)
            SELECTED = Selected.create(WoodCutterHut.create, cost)
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
