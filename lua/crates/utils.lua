local Module = {}

Module.is_cargo_toml = function()
    local current_buffer_name = vim.api.nvim_buf_get_name(0)
    local result = string.match(current_buffer_name, "Cargo.toml$")

    if result then
        return true
    end

    return false
end

Module.register_highlight_group = function(group, colour)
    vim.cmd("highlight " .. group .. " guifg=" .. colour)
end

return Module
