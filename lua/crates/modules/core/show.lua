local curl = require("plenary.curl")
local toml = require("crates.imports.toml")
local json = require("crates.imports.json")
local semver = require("crates.imports.semver")
local config = require("crates.config")
local GLOBALS = require("crates.globals")
local CONSTANTS = require("crates.constants")

local is_valid_cargo_toml = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local is_cargo_toml = string.match(bufname, "Cargo.toml$")
    local bufsize = vim.fn.getfsize(bufname)

    return is_cargo_toml and bufsize > 0
end

local get_dependencies = function(unstable)
    local cargo_toml = toml.parse(
        table.concat(
            vim.api.nvim_buf_get_lines(0, 0, -1, false),
            "\n"
        ), {strict = false}
    )
    local dependencies = {}
    local deps = cargo_toml.dependencies
    for name, metadata in pairs(deps) do
        if metadata.version then
            dependencies[name] = metadata.version
        else
            dependencies[name] = metadata
        end
    end
    return dependencies
end

local get_dependency_positions = function(deps)
    local dependency_positions = {}
    local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for buffer_line, buffer_line_content in pairs(content) do
        for name, version in pairs(deps) do
            local pattern_oneliner = table.concat({name, " ="})
            local pattern_table = table.concat({"[dependencies.", name, "]"})
            local oneliner_match = string.sub(buffer_line_content, 1, string.len(pattern_oneliner)) == pattern_oneliner
            local table_match = string.sub(buffer_line_content, 1, string.len(pattern_table)) == pattern_table
            if oneliner_match then
                dependency_positions[name] = buffer_line
            elseif table_match then
                local bline = buffer_line
                while bline <= #content do
                    if content[bline] == table.concat({"version = \"", version, "\""}) then
                        dependency_positions[name] = bline
                        break
                    end
                    bline = bline + 1
                end
            end
        end
    end
    return dependency_positions
end

local get_current_dependency_version = function(name, unstable)
    local url = table.concat({"https://crates.io/api/v1/crates/", name})
    local crate_info = json.decode(curl.request({
        url = url,
        method = "get",
        compressed = false,
        timeout = 900000
    }).body).crate
    if unstable then return crate_info.max_version else return crate_info.max_stable_version end

end

local get_outdated_deps = function(list, unstable)
    local deps = {}
    for name, version in pairs(list) do
        local newest = get_current_dependency_version(name, unstable)
        if semver(version) < semver(newest) then deps[name] = newest end
    end
    return deps
end

local set_virtual_text = function(deps, positions, outdated)
    local is_cargo_toml = is_valid_cargo_toml
    if not is_cargo_toml then return end
    for crate, version in pairs(deps) do
        local metadata = {}
        metadata.icon = config.options.icons.style.up_to_date
        metadata.version = version
        metadata.group = CONSTANTS.HIGHLIGHT_GROUPS.up_to_date
        if outdated[crate] then
            metadata.icon = config.options.icons.style.outdated
            metadata.version = outdated[crate]
            metadata.group = CONSTANTS.HIGHLIGHT_GROUPS.outdated
        end
        if config.options.icons.enable == false then metadata.icon = "" end
        local virtual_text = table.concat({metadata.icon, metadata.version})

        vim.api.nvim_buf_set_extmark(0, GLOBALS.namespace.id, positions[crate] - 1, 0, {
            virt_text = { { virtual_text, metadata.group } },
            virt_text_pos = "eol",
            priority = 200,
        })
    end
end


return function()
    if not is_valid_cargo_toml() then return end

    local dependencies = get_dependencies(config.options.unstable)
    local dependency_positions = get_dependency_positions(dependencies)
    local outdated_deps = get_outdated_deps(dependencies, config.options.unstable)

    set_virtual_text(dependencies, dependency_positions, outdated_deps)
        
end
