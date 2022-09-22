function createTab(text, buttons)
    local button = {
        text = text,
        buttons = buttons,
        hovered = false,
        width = 140,
        height = 45,
        borderWidth = 2,

        update = function(self, x, y)
            self.x = x
            self.y = y
            self.hovered = false
            local mx, my = love.mouse.getPosition()

            if
                mx > self.x and mx < self.x + self.width and
                my > self.y and my < self.y + self.height
            then
                self.hovered = true
            end
        end,

        click = function(self)
            SELECTED_TAB = self
        end,

        draw = function(self)
            love.graphics.setColor(0.1, 0.1, 0.1)
            love.graphics.rectangle("fill", self.x - self.borderWidth, self.y - self.borderWidth, self.width + self.borderWidth * 2, self.height + self.borderWidth * 2)

            if not self.hovered then
                love.graphics.setColor(0.4, 0.4, 0.4)
            else
                love.graphics.setColor(0.5, 0.5, 0.5)
            end

            love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
            love.graphics.setColor(1, 1, 1)

            love.graphics.print(self.text, self.x + 10, self.y + 10)
        end
    }

    return button
end