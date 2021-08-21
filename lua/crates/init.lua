local ui     = require("crates.ui")
local api    = require("crates.api")
local utils  = require("crates.utils")
local buffer = require("crates.buffer")
local config = require("crates.config")

local Module = {}
Module.buffer = buffer

Module.show = function()
    is_cargo_toml = utils.is_cargo_toml()

    if is_cargo_toml then
        local dependencies = buffer.get_dependencies(config.unstable)
        local dependency_positions = buffer.get_dependency_positions(dependencies)
        local outdated_deps = api.get_outdated_deps(dependencies, config.unstable)

        ui.set_virtual_text(dependencies, dependency_positions, outdated_deps)

    end

    config.register_highlights()
end

Module.hide = function()
    vim.api.nvim_buf_clear_namespace(0, config.namespace_id, 0, -1)
end

Module.setup = function(opts)
    config.setup_options(opts)
    config.register_auto_start()
    config.register_highlights()
end

return Module
