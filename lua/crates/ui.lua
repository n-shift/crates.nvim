local CONSTANTS = require("crates.constants")
local config = require("crates.config")
local utils = require("crates.utils")

local Module = {}

Module.set_virtual_text = function(deps, positions, outdated)
    local is_cargo_toml = utils.is_cargo_toml()
    if not is_cargo_toml then
        return
    end
    for crate, version in pairs(deps) do
        local metadata = {
            version = version,
            group = CONSTANTS.HIGHLIGHT_GROUPS.up_to_date,
            icon = config.options.icons.style.up_to_date,
        }
        if outdated[crate] then
            metadata.version = outdated[crate]
            metadata.group = CONSTANTS.HIGHLIGHT_GROUPS.outdated
            metadata.icon = config.options.icons.style.outdated
        end
        if config.options.icons.enable == false then metadata.icon = "" end
        print(positions[crate])
        
        vim.api.nvim_buf_set_extmark(0, config.namespace_id, positions[crate] - 1, 0, {
            virt_text = { { metadata.icon .. metadata.version, metadata.group } },
            virt_text_pos = "eol",
            priority = 200,
        })
    end
end

return Module
