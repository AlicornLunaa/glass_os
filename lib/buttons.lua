-- Buttons API to make buttons easy
-- Parent class
local PushButton = {
    new = function(self, parent, x, y, width, height, func)
        local b = {}
        setmetatable(b, {__index = self})

        b.parent = parent
        b.x = x
        b.y = y
        b.width = width
        b.height = height
        b.color = colors.red
        b.activeColor = colors.green
        b.textColor = colors.white
        b.text = ""
        b.active = false
        b.visible = true
        b.func = func

        return b
    end,
    render = function(self)
        -- Draws the button to the screen
        if not self.visible then return end
        local t = self.parent and self.parent or term
        t.setCursorPos(self.x, self.y)
        t.setTextColor(self.textColor)

        if self.active then
            t.setBackgroundColor(self.activeColor)
        else
            t.setBackgroundColor(self.color)
        end

        for i = 0, self.height - 1 do
            t.setCursorPos(self.x, self.y + i)
            t.write(string.rep(" ", self.width))
        end

        t.setCursorPos(self.x + self.width / 2 - #self.text / 2, self.y + self.height / 2)
        t.write(self.text)
    end,
    check = function(self, event)
        -- Checks if the position given is clicking the button
        local parentPos = { self.parent.getPosition() }
        local e = event[1]

        if e ~= "mouse_click" and e ~= "mouse_up" then return end

        local side = event[2]
        local x = event[3] - parentPos[1] + 1
        local y = event[4] - parentPos[2] + 1

        if side ~= 1 then return end

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
    new = function(self, parent, x, y, width, height, onFunc, offFunc)
        local b = {}
        setmetatable(b, {__index = self})

        b.parent = parent
        b.x = x
        b.y = y
        b.width = width
        b.height = height
        b.color = colors.red
        b.activeColor = colors.green
        b.textColor = colors.white
        b.text = ""
        b.active = false
        b.visible = true
        b.onFunc = onFunc
        b.offFunc = offFunc

        return b
    end,
    render = function(self)
        -- Draws the button to the screen
        if not self.visible then return end
        local t = self.parent and self.parent or term
        t.setCursorPos(self.x, self.y)
        t.setTextColor(self.textColor)

        if self.active then
            t.setBackgroundColor(self.activeColor)
        else
            t.setBackgroundColor(self.color)
        end

        for i = 0, self.height - 1 do
            t.setCursorPos(self.x, self.y + i)
            t.write(string.rep(" ", self.width))
        end

        t.setCursorPos(self.x + self.width / 2 - #self.text / 2, self.y + self.height / 2)
        t.write(self.text)
    end,
    check = function(self, event)
        -- Checks if the position given is clicking the button
        local parentPos = { self.parent.getPosition() }
        local e = event[1]

        if e ~= "mouse_click" then return end

        local side = event[2]
        local x = event[3] + parentPos[1] - 1
        local y = event[4] + parentPos[2] - 1

        if side ~= 1 then return end

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
function createPush(parent, x, y, width, height, func)
    return PushButton:new(parent, x, y, width, height, func)
end

function createToggle(parent, x, y, width, height, onFunc, offFunc)
    return ToggleButton:new(parent, x, y, width, height, onFunc, offFunc)
end