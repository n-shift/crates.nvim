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
    unstable = false
}
local highlight_param = "guifg"

if not vim.o.termguicolors then
    highlight_param = "ctermfg"
    DEFAULT_OPTIONS.colors = {
        up_to_date = "237",
        outdated = "173",
    }
end

local register_highlight_group = function(group, color)
    vim.cmd(table.concat({"highlight ", group, " ", highlight_param, "=", color}))
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

Module.register_highlight_groups = function()
    register_highlight_group(CONSTANTS.HIGHLIGHT_GROUPS.outdated, Module.options.colors.outdated)
    register_highlight_group(CONSTANTS.HIGHLIGHT_GROUPS.up_to_date, Module.options.colors.up_to_date)
end



Module.register_colorscheme_autocmd = function()
    vim.cmd([[
    augroup CratesHighlight
    autocmd!
    autocmd Colorscheme * lua require("crates.config").register_highlight_groups()
    augroup END
    ]])
end

Module.setup = function(opts)
    Module.options = register_user_options()

    register_autostart(Module.options.autostart)
    Module.register_colorscheme_autocmd()
    Module.register_highlight_groups()
    GLOBALS.namespace.register()
end

return Module
