local toml = require("crates.imports.toml")
local api = require("crates.api")

local Module = {}

local buffer_content = function()
    return vim.api.nvim_buf_get_lines(0, 0, -1, false)
end

Module.retrieve_toml = function()
    content = buffer_content()
    return toml.parse(table.concat(content, "\n"), {strict = false})
end

Module.get_dependencies = function(unstable)
    cargo_toml = Module.retrieve_toml()
    local dependencies = {}
    local deps = cargo_toml.dependencies
    for name, metadata in pairs(deps) do
        if metadata.version then
            dependencies[name] = metadata.version
        else
            dependencies[name] = metadata
        end
        print(dependencies[name])
    end
    return dependencies
end

Module.get_dependency_positions = function(deps)
    local dependency_positions = {}
    local content = buffer_content()
    for buffer_line, buffer_line_content in pairs(content) do
        for name, _version in pairs(deps) do
            local pattern_oneliner = table.concat({name, " ="})
	    local pattern_table = table.concat({"[dependencies.", name, "]"})
	    local oneliner_match = string.sub(buffer_line_content, 1, string.len(pattern_oneliner)) == pattern_oneliner
	    local table_match = string.sub(buffer_line_content, 1, string.len(pattern_table)) == pattern_table
	    if oneliner_match or table_match then
                dependency_positions[name] = buffer_line
	    end
        end
    end
    return dependency_positions
end
return Module
