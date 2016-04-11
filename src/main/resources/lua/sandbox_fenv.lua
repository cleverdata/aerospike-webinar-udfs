local inspect = require("inspect")

local function env(func, var)
    return inspect(getfenv(_G[func])[var])
end

function get_env(rec, func, var)
    return env(func, var)
end
