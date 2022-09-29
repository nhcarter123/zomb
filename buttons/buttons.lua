function createWallButton()
    local cost =  {{ "Wood", 1 }}
    local button = createButton(
        WALL_PIECE_1_IMAGE,
        getWallTitle(),
        getWallDescription(),
        cost
    )

    button.click = function(self)
        local shape = {
            {1},
        }
        SELECTED = createSelected(shape, WALL_PIECE_1_IMAGE, createWall, 0, 0, cost)
        SELECTED.scale = 0.5
    end

    return button
end

function createOutpostButton()
    local cost =  {{ "Wood", 6 }}
    local button = createButton(
        TOWER_IMAGE,
        getTowerTitle(),
        getTowerDescription(),
        cost
    )

    button.baseScale = 0.5

    button.click = function(self)
        local shape = {
            {1},
        }
        SELECTED = createSelected(shape, TOWER_IMAGE, createOutpost, 0, 0, cost)
        SELECTED.scale = 0.5
    end

    return button
end

function createFarmButton()
    local cost =  {{ "Wood", 3 }, { "Food", 3 }}
    local button = createButton(
        FARM_IMAGE,
        getFarmTitle(),
        getFarmDescription(),
        cost
    )

    button.baseScale = 0.25

    button.click = function(self)
        local shape = {
            {1, 1},
            {1, 1},
        }
        SELECTED = createSelected(shape, FARM_IMAGE, createFarm, 0.5, 0.5, cost)
        SELECTED.scale = 0.5
    end

    return button
end

function createStorageButton()
    local cost =  {{ "Wood", 15 }}
    local button = createButton(
        STORAGE_ROOF_IMAGE,
        getGraneryTitle(),
        getGraneryDescription(),
        cost
    )

    button.baseScale = 0.25

    button.click = function(self)
        local shape = {
            {1, 1},
            {1, 1},
        }
        SELECTED = createSelected(shape, STORAGE_ROOF_IMAGE, createStorage, 0.5, 0.5, cost)
        SELECTED.scale = 0.5
    end

    return button
end

function createHouseButton()
    local cost =  {{ "Wood", 5 }}
    local button = createButton(
        HOUSE_2_IMAGE,
        getHouseTitle(),
        getHouseDescription(),
        cost
    )

    button.baseScale = 0.25

    button.click = function(self)
        local shape = {
            {1},
            {1},
        }
        SELECTED = createSelected(shape, HOUSE_2_IMAGE, createHouse, 0, 0.5, cost)
        SELECTED.scale = 0.5
    end

    return button
end