function createOutpostButton()
    local button = createButton(SANDBAGS_IMAGE)

    button.baseContentScale = 1

    button.click = function(self)
        local shape = {
            {1},
        }
        SELECTED = createSelected(shape, SANDBAGS_IMAGE, createSandbags, 0, 0, 4)
    end

    return button
end

function createStorageButton()
    local button = createButton(SANDBAGS_IMAGE)

    button.baseContentScale = 1

    button.click = function(self)
        local shape = {
            {1, 1},
            {1, 1},
        }
        SELECTED = createSelected(shape, SANDBAGS_IMAGE, createStorage, 0.5, 0.5, 4)
        SELECTED.scale = 0.5
    end

    return button
end