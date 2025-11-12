-- lua_source {{{
local version = require("kurokoji-utils.version")
local set = require("kurokoji-utils.set")

local mason_lspconfig = require("mason-lspconfig")

local manual_enable_servers = {
	"serve_d",
	"lua_ls",
	"ts_ls",
	"eslint",
	"denols",
	"biome",
}

mason_lspconfig.setup({
	automatic_enable = {
		exclude = manual_enable_servers,
	},
})

local lspconfig = require("lspconfig")

local installed_servers = mason_lspconfig.get_installed_servers()

-- 積集合とって、手動で有効化するサーバーを取得
local current_manual_enable_servers = set.intersection(manual_enable_servers, installed_servers)

for _, server in pairs(current_manual_enable_servers) do
	if server == "serve_d" then
		-- local dmd_path = '~/scoop/apps/dmd/2.101.0/src'

		-- local dmd_path = ""
		-- if vim.fn.has("win32") == 1 then
		-- 	dmd_path = vim.fn.expand("~/scoop/apps/dmd/current/src")
		-- else
		-- 	-- dmd_path = vim.fn.system("asdf where dmd")
		-- 	local latest_version_dir = version.get_latest_version_dir("~/.asdf/installs/dmd")
		-- 	dmd_path = vim.fn.expand(latest_version_dir .. "/dmd2/src")
		-- 	print(dmd_path)
		-- end

		-- vim.lsp.config(server, {
		-- 	-- https://github.com/Pure-D/serve-d/blob/master/views/ja.txt
		-- 	settings = {
		-- 		d = {
		-- 			stdlibPath = { dmd_path .. "/phobos", dmd_path .. "/druntime", dmd_path .. "/dmd" },
		-- 			-- compiler = "ldc2",
		-- 		},
		-- 		dfmt = {
		-- 			braceStyle = "otbs",
		-- 		},
		-- 	},
		-- })

		-- vim.lsp.enable(server)
	elseif server == "lua_ls" then
		vim.lsp.config(server, {
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

		vim.lsp.enable(server)
	else
		local opts = {}
		local node_root_dir = lspconfig.util.root_pattern("package.json")
		local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0)) ~= nil

		if server == "ts_ls" then
			if not is_node_repo then
				return
			end
		elseif server == "eslint" then
			if not is_node_repo then
				return
			end
		elseif server == "biome" then
			if not is_node_repo then
				return
			end
		elseif server == "denols" then
			if is_node_repo then
				return
			end

			--[[
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
			--]]
		end

		vim.lsp.config(server, opts)
		vim.lsp.enable(server)
	end
end

if vim.fn.executable("deno") then
	local node_root_dir = lspconfig.util.root_pattern("package.json")
	local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0)) ~= nil

	if not is_node_repo then
		local opts = {}

		-- opts.root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json")
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

		vim.lsp.config("denols", opts)
		vim.lsp.enable("denols")
	end
end

if vim.fn.executable("serve-d") and vim.fn.executable("dmd") then
	local dmd_path = ""

	if vim.fn.has("win32") == 1 then
		dmd_path = vim.fn.expand("~/scoop/apps/dmd/current/src")
	else
		-- dmd_path = vim.fn.system("asdf where dmd")
		local latest_version_dir = version.get_latest_version_dir("~/.asdf/installs/dmd")

		if latest_version_dir ~= nil then
			dmd_path = vim.fn.expand(latest_version_dir .. "/dmd2/src")
		end

		-- print(dmd_path)
	end

	vim.lsp.config("serve_d", {
		-- https://github.com/Pure-D/serve-d/blob/master/views/ja.txt
		settings = {
			d = {
				stdlibPath = { dmd_path .. "/phobos", dmd_path .. "/druntime", dmd_path .. "/dmd" },
				-- compiler = "ldc2",
			},
			dfmt = {
				braceStyle = "otbs",
			},
		},
	})

	vim.lsp.enable("serve_d")
end
-- }}}
