-- lua_source {{{
require("mason-lspconfig").setup({})
local nvim_lsp = require("lspconfig")

require("mason-lspconfig").setup_handlers({
	function(server)
		if server == "serve_d" then
			-- local dmdPath = vim.fn.system('asdf where dmd')
			-- local dmdPath = '~/scoop/apps/dmd/2.101.0/src'
			local dmdPath = ""
			if vim.fn.has("win32") == 1 then
				dmdPath = vim.fn.expand("~/scoop/apps/dmd/current/src")
			else
				dmdPath = vim.fn.expand("~/.asdf/installs/dmd/2.101.1/dmd2/src")
			end

			require("lspconfig")[server].setup({
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
		else
			local opts = {}
			-- local node_root_dir = nvim_lsp.util.root_pattern("package.json")
			-- local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0)) ~= nil

			-- if server == 'tsserver' then
			--   if not is_node_repo then
			--     return
			--   end
			--   opts.root_dir = node_root_dir
			-- elseif server == 'eslint' then
			--   if not is_node_repo then
			--     return
			--   end
			--   opts.root_dir = node_root_dir
			-- elseif server == 'denols' then
			--   if is_node_repo then
			--     return
			--   end

			--   opts.root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json")
			--   opts.init_options = {
			--     lint = true,
			--     unstable = true,
			--     suggest = {
			--       imports = {
			--         hosts = {
			--           ["https://deno.land"] = true,
			--           ["https://cdn.nest.land"] = true,
			--           ["https://crux.land"] = true
			--         }
			--       }
			--     }
			--   }
			-- end

			-- opts.on_attach = function(_, bufnr)
			-- end

			require("lspconfig")[server].setup(opts)
		end
	end,
})
-- }}}