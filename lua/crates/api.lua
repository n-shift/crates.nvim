local json = require("imports.json")
local curl = require("plenary.curl")

local Module = {}

function Module.get_current_dependency_version(name)
    local url = table.concat({"https://crates.io/api/v1/crates/", name, callback = function(res)
        return res
    end
    })
    local raw = curl.get(url, { accept = "application/json", compressed = false, dump = {""} })
    return json.decode(raw).crate.max_stable_version
end

return Module
