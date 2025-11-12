require("settings/maps")
require("settings/dpp")
require("settings/lsp")
require("settings/opts")
require("settings/filetypes")

local function CloseAllFloatingWindows()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local cfg = vim.api.nvim_win_get_config(win)
		if cfg and cfg.relative ~= "" then
			pcall(vim.api.nvim_win_close, win, true)
		end
	end
end

vim.api.nvim_create_user_command("CloseAllFloatingWindows", CloseAllFloatingWindows, {})
