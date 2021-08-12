-- Update operating system
-- Variables
local args = { ... }

-- Functions
function installGlass()

end

function updateGlass()

end

function validateGlass()

end

-- Entrypoint
local function main()
    -- Check which argument was supplied
    if #args < 1 then
        print("Usage: glass_installer (install/update/validate)")
        return
    end

    if args[1] == "install" then
        installGlass()
    elseif args[2] == "update" then
        updateGlass()
    elseif args[3] == "validate" then
        validateGlass()
    else
        print("Invalid argument.\nUsage: glass_installer (install/update/validate)")
    end
end

main()