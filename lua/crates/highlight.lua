local CONSTANTS = require("crates.constants")
local config = require("crates.config")

local param = "guifg"
if not vim.o.termguicolors then
	param = "ctermfg"
end

local register = function(group, color)
	local command = table.concat({ "highlight ", group, " ", param, "=", color })
	vim.cmd(command)
end

local Module = {}

Module.apply = function()
	register(CONSTANTS.HIGHLIGHT_GROUPS.outdated, config.options.colors.outdated)
	register(CONSTANTS.HIGHLIGHT_GROUPS.up_to_date, config.options.colors.up_to_date)
end

Module.autocmd = function()
	vim.cmd([[
        augroup CratesHighlight
        autocmd!
            autocmd Colorscheme * lua require("crates.highlight").apply()
        augroup END
    ]])
end

return Module
