local aerospike = {}

-- true - record exists
-- false - record does not exist
function aerospike.exists(aerospike, record)
    return false
end

--  1 if record is being read or on a create, it already exists
-- -1 on failure
--  0 on success
function aerospike.create(aerospike, record)
    return 0
end

-- -2 if record does not exist
-- -1 on failure
--  0 on success
function aerospike.update(aerospike, record)
    return 0
end

--  1 if record does not exist
-- -1 on failure
--  0 on success
function aerospike.delete(aerospike, record)
    return 0
end

function aerospike.log(aerospike, level, message)
    io.write(string.format("[%s] %s\n", level, message))
end

return aerospike
