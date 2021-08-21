local config = require("crates.config")
local core = require("crates.modules.core")

local Module = {}

Module.show = function()
    core.show()
end

Module.hide = function()
    core.hide()
end

Module.setup = function(opts)
    config.setup(opts)
end

return Module
