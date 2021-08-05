-- Buttons API to make buttons easy
-- Parent class
local PushButton = {
    new = function(self, x, y, width, height, func)
        local b = {}
        setmetatable(b, {__index = self})

        b.x = x
        b.y = y
        b.width = width
        b.height = height
        b.color = colors.red
        b.activeColor = colors.green
        b.textColor = colors.white
        b.text = ""
        b.active = false
        b.func = func

        return b
    end,
    render = function(self)
        -- Draws the button to the screen
        term.setCursorPos(self.x, self.y)
        term.setTextColor(self.textColor)

        if self.active then
            term.setBackgroundColor(self.activeColor)
        else
            term.setBackgroundColor(self.color)
        end

        for i = 0, self.height - 1 do
            term.setCursorPos(self.x, self.y + i)
            term.write(string.rep(" ", self.width))
        end

        term.setCursorPos(self.x + self.width / 2 - #self.text / 2, self.y + self.height / 2)
        term.write(self.text)
    end,
    check = function(self, x, y)
        -- Checks if the position given is clicking the button
        if x <= self.x + self.width and x >= self.x
            and y <= self.y + self.height and y >= self.y then

            self.active = not self.active
            self:render()
            self:func()
        end
    end
}

-- Functions
function createPush(x, y, width, height, func)
    return PushButton:new(x, y, width, height, func)
end

function createToggle(x, y, width, height, on, off)
    -- Returns button ID

end