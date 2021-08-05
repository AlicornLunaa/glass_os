-- Helios is the default system GUI
local b1 = buttons.createPush(2, 4, 12, 3, function()
end )
b1.text = "PushButton"
b1:render()

local b2 = buttons.createToggle(16, 5, 12, 3, function() end, function() end )
b2.text = "Toggle"
b2.color = colors.blue
b2:render()

while true do
    local event = { os.pullEvent() }
    b1:check(event)
    b2:check(event)
end