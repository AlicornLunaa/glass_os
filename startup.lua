-- Helios bootloader
print("Helios Bootloader v1.0")

-- Allows system programs to be executed anywhere
shell.setPath(shell.path() .. ":/bin")

-- Load all the APIs
for k, v in pairs(fs.list("/lib")) do
    print("Loading API: " .. v)
    os.loadAPI(fs.combine("/lib", v))
end

-- Finish
sleep(0.25)
term.setCursorPos(1, 1)
term.clear()