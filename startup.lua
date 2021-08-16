-- Glass bootloader
print("Glass Bootloader v1.1")

-- Allows system programs to be executed anywhere
shell.setPath(shell.path() .. ":/bin")

-- Load all the APIs
for k, v in pairs(fs.list("/lib")) do
    print("Loading API: " .. v)
    os.loadAPI(fs.combine("/lib", v))
end

-- Load all the services
local processes = {}
for k, v in pairs(fs.list("/services")) do
    print("Loading service: " .. v)

    local function startService()
        shell.run(fs.combine("/services", v))
    end

    processes[#processes + 1] = startService
end

-- Finish
sleep(0.25)
term.setCursorPos(1, 1)
term.clear()

-- Start Glass
processes[#processes + 1] = function()
    shell.run("glass_installer", "update")
    shell.run("glass")
end
parallel.waitForAny(unpack(processes))