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
    check = function(self, event)
        -- Checks if the position given is clicking the button
        local e = event[1]
        local side = event[2]
        local x = event[3]
        local y = event[4]

        if side ~= 1 then return end
        if e ~= "mouse_click" and e ~= "mouse_up" then return end

        if e == "mouse_click" then
            if x < self.x + self.width and x >= self.x
                and y < self.y + self.height and y >= self.y then

                self.active = true
                self:render()
                self:func()
            end
        elseif e == "mouse_up" then
            -- Released, reset button
            self.active = false
            self:render()
        end
    end
}

local ToggleButton = {
    new = function(self, x, y, width, height, onFunc, offFunc)
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
        b.onFunc = onFunc
        b.offFunc = offFunc

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
    check = function(self, event)
        -- Checks if the position given is clicking the button
        local e = event[1]
        local side = event[2]
        local x = event[3]
        local y = event[4]

        if side ~= 1 then return end
        if e ~= "mouse_click" then return end

        if x < self.x + self.width and x >= self.x
            and y < self.y + self.height and y >= self.y then

            self.active = not self.active
            self:render()

            if self.active then
                self:onFunc()
            else
                self:offFunc()
            end
        end
    end
}

-- Functions
function createPush(x, y, width, height, func)
    return PushButton:new(x, y, width, height, func)
end

function createToggle(x, y, width, height, onFunc, offFunc)
    return ToggleButton:new(x, y, width, height, onFunc, offFunc)
end