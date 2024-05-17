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
-- }}}
