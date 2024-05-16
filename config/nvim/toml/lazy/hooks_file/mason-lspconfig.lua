-- lua_source {{{
require("mason-lspconfig").setup({})
local lspconfig = require("lspconfig")

local function get_dmd_path(callback)
	vim.fn.jobstart("asdf where dmd", {
		stdout_buffered = true,
		on_stdout = function(_, data)
			local path = nil
			for _, line in ipairs(data) do
				if line ~= "" then
					path = line
				end
			end
			if path then
				vim.notify("DMD path: " .. path, vim.log.levels.INFO, { title = "asdf where dmd" })
				callback(path)
			end
		end,
		on_stderr = function(_, data)
			-- エラーがあれば表示
			for _, line in ipairs(data) do
				if line ~= "" then
					vim.notify(line, vim.log.levels.ERROR, { title = "asdf where dmd" })
				end
			end
		end,
	})
end

local function setup_serve_d(dmdPath)
	require("lspconfig")["serve_d"].setup({
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
end

require("mason-lspconfig").setup_handlers({
	function(server)
		if server == "serve_d" then
			-- local dmdPath = vim.fn.system('asdf where dmd')
			-- local dmdPath = '~/scoop/apps/dmd/2.101.0/src'
			local dmdPath = ""
			if vim.fn.has("win32") == 1 then
				dmdPath = vim.fn.expand("~/scoop/apps/dmd/current/src")
				setup_serve_d(dmdPath)
			else
				dmdPath = vim.fn.expand("~/.asdf/installs/dmd/2.101.1/dmd2/src")
				get_dmd_path(setup_serve_d)
			end
		else
			local opts = {}
			local node_root_dir = lspconfig.util.root_pattern("package.json")
			local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0)) ~= nil

			if server == "tsserver" then
				if not is_node_repo then
					return
				end
				opts.root_dir = node_root_dir
			elseif server == "eslint" then
				if not is_node_repo then
					return
				end
				opts.root_dir = node_root_dir
			elseif server == "denols" then
				if is_node_repo then
					return
				end

				opts.root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json")
				opts.single_file_support = true
				opts.init_options = {
					lint = true,
					unstable = true,
					suggest = {
						imports = {
							hosts = {
								["https://deno.land"] = true,
								["https://cdn.nest.land"] = true,
								["https://crux.land"] = true,
							},
						},
					},
				}
			end

			opts.on_attach = function(_, bufnr) end

			require("lspconfig")[server].setup(opts)
		end
	end,
})
-- }}}
