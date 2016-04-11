local aerospike = require("aerospike")

local logger = {}

function logger.trace(msg, ...)
    aerospike:log("trace", msg:format(...))
end

function logger.debug(msg, ...)
    aerospike:log("debug", msg:format(...))
end

function logger.info(msg, ...)
    aerospike:log("info", msg:format(...))
end

function logger.warn(msg, ...)
    aerospike:log("warn", msg:format(...))
end

return logger
