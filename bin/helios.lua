-- Helios is the default system GUI
-- Variables
local width, height = term.getSize()
local helios = {}

helios.startMenu = {}
helios.startMenu.open = false
helios.startMenu.buttons = {}

-- Graphics
local wallpaper = paintutils.loadImage("/usr/wallpapers/win98.nfp")
local desktop = window.create(term.current(), 1, 1, width, height, true)
local startMenu = window.create(term.current(), 1, height - 17, 17, 16, false)

local startButton = buttons.createPush(desktop, 1, height - 1, 7, 2, function()
    helios.startMenu.open = not helios.startMenu.open
    startMenu.setVisible(helios.startMenu.open)

    if not helios.startMenu.open then
        desktop.redraw()
    end
end )
startButton.color = colors.cyan
startButton.activeColor = colors.blue
startButton.text = "Start"

-- Functions
function helios:drawBackground()
    -- Resets the screen and draws the background
    desktop.setCursorPos(1, 1)
    desktop.setBackgroundColor(colors.black)
    desktop.setTextColor(colors.white)
    desktop.clear()

    desktop.setBackgroundColor(colors.blue)
    desktop.setCursorPos(1, height - 0)
    desktop.clearLine()
    desktop.setCursorPos(1, height - 1)
    desktop.clearLine()

    for i,row in pairs(wallpaper) do
        desktop.setCursorPos(1, i)

        for _,col in pairs(row) do
            desktop.setBackgroundColor(col)
            desktop.write(" ")
        end
    end

    startButton:render(desktop)
end

function helios:drawStartMenu()
    -- Variables
    local w, h = startMenu.getSize()

    -- GUI
    startMenu.setCursorPos(1, 1)
    startMenu.setBackgroundColor(colors.lightGray)
    startMenu.setTextColor(colors.white)
    startMenu.clear()

    startMenu.setBackgroundColor(colors.gray)
    startMenu.setCursorPos(1, 1)
    startMenu.clearLine()
    startMenu.setCursorPos(1, 2)
    startMenu.clearLine()

    startMenu.setCursorPos(w / 2 - #"Helios" / 2 + 1, 2)
    startMenu.write("Helios")

    -- Buttons
    helios.startMenu.buttons.shutdown = buttons.createPush(startMenu, w / 2 - w / 4, h - 1, 10, 1, function() os.shutdown() end )
    helios.startMenu.buttons.shutdown.text = "Shutdown"
    helios.startMenu.buttons.shutdown:render()

    helios.startMenu.buttons.reboot = buttons.createPush(startMenu, w / 2 - w / 4, h - 3, 10, 1, function() os.reboot() end )
    helios.startMenu.buttons.reboot.text = "Reboot"
    helios.startMenu.buttons.reboot:render()
end

function helios:main()
    -- Main entrypoint
    helios:drawBackground()
    helios:drawStartMenu()

    while true do
        -- Read events
        local event = { os.pullEvent() }
        startButton:check(event)

        if helios.startMenu.open then
            -- Start menu is open, check the buttons
            for k,v in pairs(helios.startMenu.buttons) do
                v:check(event)
            end
        end
    end
end

-- Startup
helios:main()