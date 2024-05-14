-- lua_add {{{
local function on_cursor_hold()
	if vim.lsp.buf.server_ready() then
		vim.diagnostic.open_float()
	end
end

-- local diagnostic_hover_augroup_name = "lspconfig-diagnostic"
-- vim.api.nvim_set_option("updatetime", 500)
-- vim.api.nvim_create_augroup(diagnostic_hover_augroup_name, { clear = true })
-- vim.api.nvim_create_autocmd({ "CursorHold" }, {
--   group = diagnostic_hover_augroup_name,
--   callback = on_cursor_hold
-- })

-- vim.diagnostic.config({ virtual_text = false })
-- }}}

-- lua_source {{{
local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local nvim_lsp = require("lspconfig")

local dmdPath = ""
if vim.fn.has("win32") == 1 then
	dmdPath = vim.fn.expand("~/scoop/apps/dmd/current/src")
else
	dmdPath = vim.fn.expand("~/.asdf/installs/dmd/2.101.1/dmd2/src")
end

nvim_lsp["serve_d"].setup({
	-- https://github.com/Pure-D/serve-d/blob/master/views/ja.txt
	settings = {
		d = {
			stdlibPath = { dmdPath .. "/phobos", dmdPath .. "/druntime", dmdPath .. "/dmd" },
		},
		dfmt = {
			braceStyle = "otbs",
		},
	},
})
-- }}}
