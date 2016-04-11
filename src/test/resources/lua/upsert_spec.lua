require("matchers")

describe("upsert", function()
    local match = require("luassert.match")

    local aerospike
    local record = require("record")
    local logger = require("logger")
    require("utils")

    require("upsert")
    local env

    before_each(function()
        aerospike = require("aerospike")
        env = getfenv(upsert)
    end)

    after_each(function()
        -- unload explicitly as we will be replacing update function
        aerospike = unrequire("aerospike")
        setfenv(upsert, env)
    end)

    it("should update existing record", function()
        --noinspection UnusedDef
        aerospike.update = function(aerospike, record)
            return 0
        end
        aerospike = mock(aerospike)

        local env = {
            ["aerospike"] = aerospike,
            ["record"] = record,
            ["debug"] = logger.debug,
            ["_G"] = {}
        }

        local actual = record_new("key", 3600, 0, {}, "data")
        local expected = record_new("key", 3600, 0, {["binName"] = "binValue"}, "data")

        setfenv(upsert, env)
        assert.are.equals(upsert(actual, "binName", "binValue"), nil)

        assert.spy(aerospike.update).was_called_with(match.same(aerospike), match.same(expected))
        assert.spy(aerospike.create).was.not_called()
    end)

    it("should create record if it does not exist", function()
        --noinspection UnusedDef
        aerospike.update = function(aerospike, record)
            return -2
        end
        aerospike = mock(aerospike)

        local env = {
            ["aerospike"] = aerospike,
            ["record"] = record,
            ["debug"] = logger.debug,
            ["_G"] = {}
        }

        local actual = record_new("key", 3600, 0, {}, "data")
        local expected = record_new("key", 3600, 0, {["binName"] = "binValue"}, "data")

        setfenv(upsert, env)
        assert.are.equals(upsert(actual, "binName", "binValue"), nil)

        assert.spy(aerospike.create).was_called_with(match.same(aerospike), match.same(expected))
        assert.spy(aerospike.update).was_called_with(match.same(aerospike), match.same(expected))
    end)

end)
