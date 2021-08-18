local json = require("crates.imports.json")

local Module = {}

function Module:get_outdated_dependencies(callback)
    local command = "cargo outdated --format json"
    local finished = false

    vim.fn.jobstart(command, {
        on_stdout = function(_, stdout)
            if finished == false then
                local string_value = table.concat(stdout)
		local json_value = json.decode(string_value)

		callback(json_value)
            end

	    finished = true
        end,
	on_stderr = function(_, stderr)
            if stderr[0] ~= nil then
                vim.api.nvim_echo({ { "Crates info retrieval failed.", "WarningMsg" } }, {}, {})
            end
        end,
    })
end

return Module
