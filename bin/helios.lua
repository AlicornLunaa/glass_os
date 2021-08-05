-- Helios is the default system GUI
-- Variables
local width, height = term.getSize()
local helios = {}

-- Graphics
local wallpaper = paintutils.loadImage("/usr/wallpapers/win98.nfp")
local startButton = buttons.createPush(1, height - 1, 7, 2, function()
end )
startButton.color = colors.cyan
startButton.activeColor = colors.blue
startButton.text = "Start"

-- Functions
function helios:drawBackground()
    -- Resets the screen and draws the background
    term.setCursorPos(1, 1)
    term.setBackgroundColor(colors.lightBlue)
    term.setTextColor(colors.white)
    term.clear()

    term.setBackgroundColor(colors.blue)
    term.setCursorPos(1, height - 0)
    term.clearLine()
    term.setCursorPos(1, height - 1)
    term.clearLine()

    paintutils.drawImage(wallpaper, 1, 1)

    startButton:render()
end

function helios:drawDesktop()

end

function helios:main()
    -- Main entrypoint
    helios:drawBackground()

    while true do
        -- Read events
        local event = { os.pullEvent() }
        startButton:check(event)
    end
end

-- Startup
helios:main()