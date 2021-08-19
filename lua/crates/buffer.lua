local toml = require("crates.imports.toml")

local Module = {}

Module.buffer_content = function()
    return vim.api.nvim_buf_get_lines(0, 0, -1, false)
end

Module.retrieve_toml = function()
    content = Module.buffer_content()
    return Toml.parse(table.concat(content, "\n"), {strict = false})
end

Module.get_dependency_names = function()
    cargo_toml = Module.retrieve_toml()
    local dependencies_names = {}
    local dependencies = cargo_toml.dependencies
    for dep in dependencies do
        table.insert(dependencies_names, tostring(dep))
    end
end

Module.get_dependency_positions = function(names)
    local dependency_positions = {}
    local buffer_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for buffer_line, buffer_line_content in pairs(buffer_content) do
        for _, name in pairs(names) do
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
