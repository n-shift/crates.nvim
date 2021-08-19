local curl = require('plenary.curl')
local json = require('imports.json')
local semver = require('imports.semver')

local Module = {}

Module.get_current_dependency_version = function(name, unstable)
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

Module.get_outdated_deps = function(list, unstable)
    local deps = {}
    for name, version in pairs(list) do
        local newest = Module.get_current_dependency_version(name, unstable)
	if semver(version) < semver(newest) then deps[name] = version end
    end

    return deps
end

return Module
