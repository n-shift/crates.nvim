local curl = require('plenary.curl')
local json = require('imports.json')

local Module = {}

function Module.get_current_dependency_version(name, unstable)
    local url = table.concat({"https://crates.io/api/v1/crates/", name})
    body = curl.request({
        url = url,
	method = "get",
	accepts = "application/json",
	compressed = false,
	timeout = 900000
    }).body
    
    local crate_info = json.decode(body).crate

    if unstable then return crate_info.max_version else return crate_info.max_stable_version end

end

return Module
