-- Helios is the default system GUI
-- Variables
local width, height = term.getSize()
local helios = {}

helios.startOpen = false

-- Graphics
local wallpaper = paintutils.loadImage("/usr/wallpapers/win98.nfp")
local desktop = window.create(term.current(), 1, 1, width, height, true)
local startMenu = window.create(term.current(), 1, height - 17, 17, 16, false)

local startButton = buttons.createPush(desktop, 1, height - 1, 7, 2, function()
    helios.startOpen = not helios.startOpen
    startMenu.setVisible(helios.startOpen)

    if not helios.startOpen then
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
    startMenu.setCursorPos(1, 1)
    startMenu.setBackgroundColor(colors.lightGray)
    startMenu.setTextColor(colors.white)
    startMenu.clear()

    startMenu.setBackgroundColor(colors.gray)
    startMenu.setCursorPos(1, 1)
    startMenu.clearLine()
    startMenu.setCursorPos(1, 2)
    startMenu.clearLine()

    startMenu.setCursorPos(17 / 2 - #"Helios" / 2 + 1, 2)
    startMenu.write("Helios")
end

function helios:main()
    -- Main entrypoint
    helios:drawBackground()
    helios:drawStartMenu()

    while true do
        -- Read events
        local event = { os.pullEvent() }
        startButton:check(event)
    end
end

-- Startup
helios:main()