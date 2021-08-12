-- Update operating system
-- Variables
local masterBranch = "https://raw.githubusercontent.com/AlicornLunaa/glass_os/master"
local args = { ... }

-- Functions
function checkHttp()
    -- Checks if the http connection is even valid
    if not http.checkURL("https://github.com/AlicornLunaa/glass_os") then
        print("Unable to contact Github.")
        return false
    end

    print("Connection to Github ok.")
    return true
end

function getHttpData(url)
    -- Gets a file from HTTP protocol and returns the data
    local res = http.get(url)
    local data = res.readAll()
    res.close()

    return data
end

function installGlass()
    -- Get all the files from github
    print("Installing Glass...")
    if not checkHttp() then return end

    -- Obtain the package information for which files to download
    term.write("Getting package details...")
    local pkg = textutils.unserialiseJSON(getHttpData(masterBranch .. "/package.json"))
    print(" Done!")

    -- Create directories listed
    if pkg then
        print("Creating file structure...")
        for _,v in pairs(pkg.directories) do
            print("Creating directory " .. v)
            fs.makeDir(v)
        end
        print("Done!")

        print("Downloading files...")
        for _,v in pairs(pkg.files) do
            print("Downloading file " .. v)
            local data = getHttpData(pkg.masterUrl .. pkg.files)
            local f = fs.open(v, "w")
            f.write(data)
            f.close()
        end
        print("Done!")
    else
        print("Unknown error!")
        return
    end
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