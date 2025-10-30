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


local function set_keymaps(buf)
	-- vim.diagnostic.config({ virtual_text = false })
	local opts = {
		silent = true,
		buffer = buf,
	}

	vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<Leader>h", vim.lsp.buf.hover, opts)
	-- vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<Leader>f", vim.diagnostic.open_float, opts)
	-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	-- vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
	-- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	-- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

	vim.keymap.set("n", "g]", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
	vim.keymap.set("n", "g[", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)

	vim.keymap.set("n", "F", function() vim.lsp.buf.format({ async = true }) end, opts)
end

local function set_signs()
local signs = { Error = "", Warn = "", Hint = "", Info = "" }
	vim.diagnostic.config({
		signs = {
			-- :help dianostic-signs
			text = {
				[vim.diagnostic.severity.ERROR] = signs["Error"],
				[vim.diagnostic.severity.WARN] = signs["Warn"],
				[vim.diagnostic.severity.INFO] = signs["Info"],
				[vim.diagnostic.severity.HINT] = signs["Hint"],
			},
			numhl = {
			},
			linehl = {
			},
			float = {
				border = "rounded",
				severity_sort = true,
			},
		},
	})
end

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		set_keymaps(ev.buf)
		set_signs()
	end
})
