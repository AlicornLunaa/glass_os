-- Creates files
local args = { ... }

function main()
    if #args < 1 then
        print("Usage: touch (file) [file...]")
        return
    end

    for k, v in pairs(args) do
        local f = fs.open(v, "w")
        f.close()
    end
end

main()