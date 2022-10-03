function createWallButton()
    local cost =  {{ "Wood", 1 }}
    local button = createButton(
        WALL_PIECE_1_IMAGE,
        Wall.getTitle(),
        Wall.getDescription(),
        cost
    )

    button.click = function(self)
        local shape = {
            {1},
        }
        SELECTED = createSelected(shape, WALL_PIECE_1_IMAGE, Wall, 0, 0, cost)
        SELECTED.scale = 0.5
    end

    return button
end

function createOutpostButton()
    local cost =  {{ "Wood", 6 }}
    local button = createButton(
        TOWER_IMAGE,
        Tower.getTitle(),
        Tower.getDescription(),
        cost
    )

    button.baseScale = 0.5

    button.click = function(self)
        local shape = {
            {1},
        }
        SELECTED = createSelected(shape, TOWER_IMAGE, Tower, 0, 0, cost)
        SELECTED.scale = 0.5
    end

    return button
end

function createFarmButton()
    local cost =  {{ "Wood", 3 }, { "Food", 3 }}
    local button = createButton(
        FARM_IMAGE,
        Farm.getTitle(),
        Farm.getDescription(),
        cost
    )

    button.baseScale = 0.25

    button.click = function(self)
        local shape = {
            {1, 1},
            {1, 1},
        }
        SELECTED = createSelected(shape, FARM_IMAGE, Farm, 0.5, 0.5, cost)
        SELECTED.scale = 0.5
    end

    return button
end

function createStorageButton()
    local cost =  {{ "Wood", 15 }}
    local button = createButton(
        STORAGE_ROOF_IMAGE,
        Storage.getTitle(),
        Storage.getDescription(),
        cost
    )

    button.baseScale = 0.25

    button.click = function(self)
        local shape = {
            {1, 1},
            {1, 1},
        }
        SELECTED = createSelected(shape, STORAGE_ROOF_IMAGE, Storage, 0.5, 0.5, cost)
        SELECTED.scale = 0.5
    end

    return button
end

function createHouseButton()
    local cost =  {{ "Wood", 5 }}
    local button = createButton(
        HOUSE_2_IMAGE,
        House.getTitle(),
        House.getDescription(),
        cost
    )

    button.baseScale = 0.25

    button.click = function(self)
        local shape = {
            {1},
            {1},
        }
        SELECTED = createSelected(shape, HOUSE_2_IMAGE, House, 0, 0.5, cost)
        SELECTED.scale = 0.5
    end

    return button
end

function createWoodCutterHutButton()
    local cost =  {{ "Wood", 5 }}
    local button = createButton(
        WOOD_CUTTER_HUT_IMAGE,
        WoodCutterHut.getTitle(),
        WoodCutterHut.getDescription(),
        cost
    )

    button.baseScale = 0.5

    button.click = function(self)
        local shape = {
            {1},
        }
        SELECTED = createSelected(shape, WOOD_CUTTER_HUT_IMAGE, WoodCutterHut, 0, 0, cost)
        SELECTED.scale = 0.5
    end

    return button
end