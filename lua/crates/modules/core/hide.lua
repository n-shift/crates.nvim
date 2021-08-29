local globals = require("crates.globals")

return function()
	vim.api.nvim_buf_clear_namespace(0, globals.namespace.id, 0, -1)
end
