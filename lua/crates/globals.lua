local Module = {}

Module.namespace = {
	register = function()
		Module.namespace.id = vim.api.nvim_create_namespace("crates")
	end,
}

Module.buffer = {}

return Module
