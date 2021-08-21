local CONSTANTS = require("crates.constants")
local utils = require("crates.utils")

local Module = {}

Module.setup_options = function(options)
    Module.options = vim.tbl_deep_extend("force", {}, CONSTANTS.DEFAULT_OPTIONS, options or {})
end

Module.register_auto_start = function()
    if Module.options.autostart then
        vim.api.nvim_exec(
	    [[ augroup CratesUI
	        autocmd!
		autocmd BufWinEnter,WinNew * lua require("crates").show()
	    augroup end]],
	    false
	)
    end
end

Module.register_highlights = function()
    Module.namespace_id = vim.api.nvim_create_namespace("crates-ui")

    utils.register_highlight_group(CONSTANTS.HIGHLIGHT_GROUPS.outdated, Module.options.colors.outdated)
    utils.register_highlight_group(CONSTANTS.HIGHLIGHT_GROUPS.up_to_date, Module.options.colors.up_to_date)
end

return Module
