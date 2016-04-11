local assert = require("luassert")

local function has_property(state, arguments)
    local property = arguments[1]
    local expected = arguments[2]
    return function(actual)
        return type(actual) == "table" and actual[property] == expected
    end
end

assert:register("matcher", "has_property", has_property)