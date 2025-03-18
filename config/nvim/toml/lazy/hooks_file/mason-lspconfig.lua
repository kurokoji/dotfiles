-- lua_source {{{
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({})

local lspconfig = require("lspconfig")

mason_lspconfig.setup_handlers({
	function(server)
		if server == "serve_d" then
			-- local dmdPath = '~/scoop/apps/dmd/2.101.0/src'
			local dmdPath = ""
			if vim.fn.has("win32") == 1 then
				dmdPath = vim.fn.expand("~/scoop/apps/dmd/current/src")
			else
				-- dmdPath = vim.fn.system("asdf where dmd")
				dmdPath = vim.fn.expand("~/.asdf/installs/dmd/2.102.0/src")
			end

			lspconfig[server].setup({
				-- https://github.com/Pure-D/serve-d/blob/master/views/ja.txt
				settings = {
					d = {
						stdlibPath = { dmdPath .. "/phobos", dmdPath .. "/druntime", dmdPath .. "/dmd" },
						-- compiler = "ldc2",
					},
					dfmt = {
						braceStyle = "otbs",
					},
				},
			})
		elseif server == "lua_ls" then
			lspconfig[server].setup({
				on_init = function(client)
					local path = client.workspace_folders[1].name
					if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
						return
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								-- Depending on the usage, you might want to add additional paths here.
								-- "${3rd}/luv/library"
								-- "${3rd}/busted/library",
							},
							-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
							-- library = vim.api.nvim_get_runtime_file("", true)
						},
					})
				end,
				settings = {
					Lua = {},
				},
			})
		else
			local opts = {}
			local node_root_dir = lspconfig.util.root_pattern("package.json")
			local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0)) ~= nil

			if server == "ts_ls" then
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
				--[[
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
				]]
			end

			opts.on_attach = function(_, bufnr) end

			lspconfig[server].setup(opts)
		end
	end,
})

vim.api.nvim_exec_autocmds("User", { pattern = "MasonLspConfigLoaded" })

-- print("project_name_to_container_name: " .. project_name_to_container_name())
-- if vim.fn.executable("rubocop") then
-- 	lspconfig["rubocop"].setup({
-- 		cmd = { "bundle", "exec", "rubocop", "--lsp" },
-- 	})
-- end

-- if vim.fn.executable("sorbet") then
-- 	lspconfig["sorbet"].setup({
-- 		cmd = { "bundle", "exec", "srb", "tc", "--lsp" },
-- 	})
-- end

if vim.fn.executable("deno") then
	local node_root_dir = lspconfig.util.root_pattern("package.json")
	local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0)) ~= nil

	if not is_node_repo then
		local opts = {}

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

		opts.on_attach = function(_, bufnr) end

		lspconfig["denols"].setup(opts)
	end
end

-- }}}
