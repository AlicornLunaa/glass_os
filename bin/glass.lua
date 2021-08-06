-- glass is the default system GUI
-- Variables
local width, height = term.getSize()
local glass = {}

glass.startMenu = {}
glass.startMenu.open = false
glass.startMenu.buttons = {}

glass.applications = {}

-- Graphics
local wallpaper = paintutils.loadImage("/usr/wallpapers/win98.nfp")
local desktop = window.create(term.current(), 1, 1, width, height, true)
local startMenu = window.create(term.current(), 1, height - 17, 17, 16, false)

local startButton = buttons.createPush(desktop, 1, height - 1, 7, 2, function()
    glass.startMenu.open = not glass.startMenu.open
    startMenu.setVisible(glass.startMenu.open)

    if not glass.startMenu.open then
        desktop.redraw()
    end
end )
startButton.color = colors.cyan
startButton.activeColor = colors.blue
startButton.text = "Start"

-- Functions
function glass:drawBackground()
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

    -- Render each application
    for k, v in pairs(glass.applications) do
        v.btn:render(desktop)
    end
end

function glass:drawStartMenu()
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

    startMenu.setCursorPos(w / 2 - #"Glass" / 2 + 1, 2)
    startMenu.write("Glass")

    -- Buttons
    glass.startMenu.buttons.shutdown = buttons.createPush(startMenu, w / 2 - w / 4, h - 1, 10, 1, function() os.shutdown() end )
    glass.startMenu.buttons.shutdown.text = "Shutdown"
    glass.startMenu.buttons.shutdown:render()

    glass.startMenu.buttons.reboot = buttons.createPush(startMenu, w / 2 - w / 4, h - 3, 10, 1, function() os.reboot() end )
    glass.startMenu.buttons.reboot.text = "Reboot"
    glass.startMenu.buttons.reboot:render()
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
    glass:drawStartMenu()

    while true do
        -- Read events
        local event = { os.pullEvent() }
        startButton:check(event)

        for k,v in pairs(glass.applications) do
            v.btn:check(event)
        end

        if glass.startMenu.open then
            -- Start menu is open, check the buttons
            for k,v in pairs(glass.startMenu.buttons) do
                v:check(event)
            end
        end
    end
end

-- Startup
glass:main()