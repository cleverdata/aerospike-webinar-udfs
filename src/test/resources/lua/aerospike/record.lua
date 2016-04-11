function record_new(key, ttl, gen, bins, set)
    local rec = {
        ["__meta"] = {
            ["key"] = key,
            ["digest"] = key,
            ["ttl"] = ttl,
            ["gen"] = gen,
            ["set"] = set
        }
    }

    for key, val in pairs(bins) do
        rec[key] = val
    end

    return rec
end

-- Aerospike API emulation

local record = {}

function record.bin_names(rec)
    local keyset = {}
    local ind = 0

    for key, val in pairs(rec) do
        if (key ~= "__meta") then
            ind = ind + 1
            keyset[ind] = key
        end
    end

    return keyset
end

function record.digest(rec)
    return rec["__meta"]["digest"]
end

function record.gen(rec)
    return rec["__meta"]["gen"]
end

function record.key(rec)
    return rec["__meta"]["key"]
end

function record.setname(rec)
    return rec["__meta"]["set"]
end

function record.ttl(rec)
    return rec["__meta"]["ttl"]
end

function record.set_ttl(rec, ttl)

end

function record.drop_key(rec)
    rec["__meta"]["key"] = nil
end

return record
