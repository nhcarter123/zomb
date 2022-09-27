function createWallButton()
    local button = createButton(
        WALL_PIECE_1_IMAGE,
        getWallTitle(),
        getWallDescription()
    )

    button.click = function(self)
        local shape = {
            {1},
        }
        SELECTED = createSelected(shape, WALL_PIECE_1_IMAGE, createWall, 0, 0, 4)
        SELECTED.scale = 0.5
    end

    return button
end

function createOutpostButton()
    local button = createButton(
        TOWER_IMAGE,
        getTowerTitle(),
        getTowerDescription()
    )

    button.baseScale = 0.5

    button.click = function(self)
        local shape = {
            {1},
        }
        SELECTED = createSelected(shape, TOWER_IMAGE, createOutpost, 0, 0, 4)
        SELECTED.scale = 0.5
    end

    return button
end

function createFarmButton()
    local button = createButton(
        FARM_IMAGE,
        getFarmTitle(),
        getFarmDescription()
    )

    button.baseScale = 0.25

    button.click = function(self)
        local shape = {
            {1, 1},
            {1, 1},
        }
        SELECTED = createSelected(shape, FARM_IMAGE, createFarm, 0.5, 0.5, 4)
        SELECTED.scale = 0.5
    end

    return button
end

function createStorageButton()
    local button = createButton(
        STORAGE_ROOF_IMAGE,
        getGraneryTitle(),
        getGraneryDescription()
    )

    button.baseScale = 0.25

    button.click = function(self)
        local shape = {
            {1, 1},
            {1, 1},
        }
        SELECTED = createSelected(shape, STORAGE_ROOF_IMAGE, createStorage, 0.5, 0.5, 4)
        SELECTED.scale = 0.5
    end

    return button
end

function createHouseButton()
    local button = createButton(
        HOUSE_2_IMAGE,
        getHouseTitle(),
        getHouseDescription()
    )

    button.baseScale = 0.25

    button.click = function(self)
        local shape = {
            {1},
            {1},
        }
        SELECTED = createSelected(shape, HOUSE_2_IMAGE, createHouse, 0, 0.5, 5)
        SELECTED.scale = 0.5
    end

    return button
end