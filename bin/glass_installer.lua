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

    print("Connection to Github OK.")
    return true
end

function getHttpData(url)
    -- Gets a file from HTTP protocol and returns the data
    local res = http.get(url)
    local data = res.readAll()
    res.close()

    return data
end

function getFileData(url)
    local f = fs.open(url, "r")
    local data = f.readAll()
    f.close()

    return data
end

function installGlass(parent)
    -- Get all the files from github
    print("Installing Glass...")
    if not checkHttp() then return false end
    parent = parent or ""

    -- Obtain the package information for which files to download
    term.write("Getting package details...")
    local pkg = textutils.unserialiseJSON(getHttpData(masterBranch .. "/package.json"))
    print(" Done!")

    -- Create directories listed
    if pkg then
        print("Creating file structure...")
        for _,v in pairs(pkg.directories) do
            print("Creating directory " .. v)
            fs.makeDir(parent .. v)
        end
        print("Done!")

        print("Downloading files...")
        for _,v in pairs(pkg.files) do
            print("Downloading file " .. v)
            local data = getHttpData(pkg.masterUrl .. v)
            local f = fs.open(parent .. v, "w")
            f.write(data)
            f.close()
        end
        print("Done!")

        -- Move installer into the bin folder
        fs.move("./glass_installer.lua", parent .. "/bin/")
        return true
    else
        print("Unknown error!")
        return false
    end
end

function updateGlass()
    -- Get all the files from github
    print("Checking for updates...")
    if not checkHttp() then return end

    -- Obtain the package information for which files to download
    term.write("Getting newest version...")
    local publicVersion = tonumber(getHttpData(masterBranch .. "/version.txt"))
    local f = fs.open("/version.txt", "r")
    local deviceVersion = tonumber(f.readAll())
    f.close()
    print(" Done!\nNewest version: " .. publicVersion .. "\nCurrent version: " .. deviceVersion .. "\n")

    -- Continue with update
    if publicVersion > deviceVersion then
        print("New update available.\nWould you like to continue? (Y/N) ")
        local res = read()

        if string.lower(res) == "y" then
            print("Updating Glass...")

            fs.makeDir("/temp")
            if installGlass("/temp") then
                -- Update worked, remove the temporary directory with all the new files and move it to root
                local pkg = textutils.unserialiseJSON(getFileData("/package.json"))

                for _,v in pairs(pkg.files) do
                    fs.delete(v)
                end

                fs.move("/temp/*", "/")
                fs.delete("/temp")

                print("Update complete!")
            else
                print("Update unsuccessful.")
            end
        else
            print("Skipping update.")
        end
    else
        print("No new updates.")
    end
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
    elseif args[1] == "update" then
        updateGlass()
    elseif args[1] == "validate" then
        validateGlass()
    else
        print("Invalid argument.\nUsage: glass_installer (install/update/validate)")
    end
end

main()