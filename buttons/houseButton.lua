function createHouseButton()
    local button = createButton(HOUSE_IMAGE)

    button.baseContentScale = 0.5

    button.click = function(self)
        local shape = {
            {1},
            {1},
        }
        SELECTED = createSelected(shape, HOUSE_IMAGE, createHouse, 0, 0.5, 5)
    end

    return button
end