local CONSTANTS = require("crates.constants")
local GLOBALS = require("crates.globals")

local DEFAULT_OPTIONS = {
	colors = {
		up_to_date = "#3C4048",
		outdated = "#d19a66",
	},
	icons = {
		enable = true,
		style = {
			up_to_date = "|  ",
			outdated = "|  ",
		},
	},
	autostart = false,
	unstable = false,
}
if not vim.o.termguicolors then
	DEFAULT_OPTIONS.colors = {
		up_to_date = "237",
		outdated = "173",
	}
end

local register_autostart = function(enabled)
	if enabled then
		vim.cmd([[
        augroup CratesUI
        autocmd!
        autocmd BufWinEnter,WinNew * lua require("crates").show()
        augroup end
        ]])
	end
end

local register_user_options = function(opts)
	return vim.tbl_deep_extend("force", {}, DEFAULT_OPTIONS, opts or {})
end

local Module = {}

Module.setup = function(opts)
	Module.options = register_user_options(opts)

	register_autostart(Module.options.autostart)
	GLOBALS.namespace.register()
end

return Module
