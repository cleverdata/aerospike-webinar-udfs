local greeting = {}

greeting.hello = function(name)
    return "Hello " .. tostring(name)
end

return greeting