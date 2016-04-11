local crypto = require("crypto")

function md5(rec, name, val)
    rec[name] = crypto.digest("MD5", val)
    if aerospike:update(rec) ~= 0 then
        debug("record does not exist, creating: [key: %s, bin: %s, val: %s]", record.digest(rec), name, val)
        aerospike:create(rec)
        debug("record has been created: [digest: %s, bin: %s, val: %s]", record.digest(rec), name, val)
    else
        debug("record has been updated: [digest: %s, bin: %s, val: %s]", record.digest(rec), name, val)
    end
end
