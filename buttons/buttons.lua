function createWallButton()
    local wall = Wall.create(0, 0)
    local cost =  {{ "Wood", 1 }}
    local button = createButton(wall, cost)

    button.click = function(self)
        SELECTED = createSelected(Wall.create, cost)
    end

    return button
end

function createOutpostButton()
    local tower = Tower.create(0, 0)
    local cost =  {{ "Wood", 6 }}
    local button = createButton(tower, cost)

    button.baseScale = 0.5

    button.click = function(self)
        SELECTED = createSelected(Tower.create, cost)
    end

    return button
end

function createFarmButton()
    local farm = Farm.create(0, 0)
    local cost =  {{ "Wood", 3 }, { "Food", 3 }}
    local button = createButton(farm, cost)

    button.baseScale = 0.25
    button.click = function(self)
        SELECTED = createSelected(Farm.create, cost)
    end

    return button
end

function createStorageButton()
    local storage = Storage.create(0, 0)
    local cost =  {{ "Wood", 15 }}
    local button = createButton(storage, cost)

    button.baseScale = 0.25

    button.click = function(self)
        SELECTED = createSelected(Storage.create, cost)
    end

    return button
end

function createHouseButton()
    local house = House.create(0, 0)
    local cost =  {{ "Wood", 5 }}
    local button = createButton(house, cost)

    button.baseScale = 0.25
    button.click = function(self)
        SELECTED = createSelected(House.create, cost)
    end

    return button
end

function createWoodCutterHutButton()
    local woodCutterHut = WoodCutterHut.create(0, 0)
    local cost =  {{ "Wood", 5 }}
    local button = createButton(woodCutterHut, cost)

    button.baseScale = 0.5
    button.click = function(self)
        SELECTED = createSelected(WoodCutterHut.create, cost)
    end

    return button
end