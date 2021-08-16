-- glass is the default system GUI
-- Variables
local width, height = term.getSize()
local glass = {}

glass.homeScreen = {}
glass.homeScreen.open = true
glass.homeScreen.page = 1
glass.homeScreen.maxPages = 17
glass.applications = {}

-- Graphics
local wallpaper = paintutils.loadImage("/usr/wallpapers/mobile_hearts.nfp")
local desktop = window.create(term.current(), 1, 1, width, height, true)

local homeButton = buttons.createPush(desktop, width / 2 - 3, height - 1, 7, 2, function()
    glass.homeScreen.open = true
    desktop.setVisible(true)

    if not glass.homeScreen.open then
        desktop.redraw()
    else
        glass.homeScreen.page = 1
    end
end )
homeButton.color = colors.cyan
homeButton.activeColor = colors.blue
homeButton.text = "Start"

local leftButton = buttons.createPush(desktop, 1, height - 1, 3, 2, function()
    glass.homeScreen.page = math.max(1, glass.homeScreen.page - 1)
end )
leftButton.color = colors.cyan
leftButton.activeColor = colors.blue
leftButton.text = "<"

local rightButton = buttons.createPush(desktop, width - 2, height - 1, 3, 2, function()
    glass.homeScreen.page = math.min(glass.homeScreen.maxPages, glass.homeScreen.page + 1)
end )
rightButton.color = colors.cyan
rightButton.activeColor = colors.blue
rightButton.text = ">"

-- Functions
function glass:drawBackground()
    -- Resets the screen and draws the background
    desktop.setCursorPos(1, 1)
    desktop.setBackgroundColor(colors.black)
    desktop.setTextColor(colors.white)
    desktop.clear()

    for i,row in pairs(wallpaper) do
        desktop.setCursorPos(1, i)

        for _,col in pairs(row) do
            desktop.setBackgroundColor(col)
            desktop.write(" ")
        end
    end

    desktop.setBackgroundColor(colors.blue)
    desktop.setCursorPos(1, height - 0)
    desktop.clearLine()
    desktop.setCursorPos(1, height - 1)
    desktop.clearLine()

    homeButton:render(desktop)
    leftButton:render(desktop)
    rightButton:render(desktop)

    -- Render each application
    for k, v in pairs(glass.applications) do
        v.btn:render(desktop)
    end
end

function glass:loadApps()
    -- Load applications into memory
    local space = 0

    for k,v in pairs(fs.list("/home/desktop/")) do
        local path = fs.combine("/home/desktop/", v)

        if not fs.isDir(path) then
            -- Load app
            local f = fs.open(path, "r")
            local data = textutils.unserialise(f.readAll())
            f.close()

            if not data.hidden then
                glass.applications[#glass.applications + 1] = data
                glass.applications[#glass.applications].btn = buttons.createPush(desktop, 2 + space, 2, #data.name + 2, 2, function() shell.run(data.command) end )
                glass.applications[#glass.applications].btn.text = data.name

                space = space + #data.name + 3
            end
        end
    end
end

function glass:main()
    -- Main entrypoint
    glass:loadApps()
    glass:drawBackground()

    while true do
        -- Show page
        desktop.redraw()
        if glass.homeScreen.open then
            local txt = string.format("%d/%d", glass.homeScreen.page, glass.homeScreen.maxPages)
            term.setCursorPos(width - #txt + 1, 1)
            term.write(txt)
        end

        -- Read events
        local event = { os.pullEvent() }
        homeButton:check(event)
        leftButton:check(event)
        rightButton:check(event)

        for k,v in pairs(glass.applications) do
            v.btn:check(event)
        end
    end
end

-- Startup
glass:main()