local config = require("crates.config")
local highlight = require("crates.highlight")
local core = require("crates.modules.core")

local Module = {}

Module.show = function()
    core.show()
    highlight.apply()
end

Module.hide = function()
    core.hide()
end

Module.setup = function(opts)
    config.setup(opts)
    highlight.autocmd()
end

return Module
