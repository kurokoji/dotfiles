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


local manual_config = {
	serve_d = function()
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
	end,
	lua_ls = function()
		vim.lsp.config("lua_ls", {
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

		vim.lsp.enable("lua_ls")
	end,
	ts_ls = function(is_node_repo)
		if not is_node_repo then
			return
		end

		vim.lsp.config("ts_ls", {})
		vim.lsp.enable("ts_ls")
	end,
	eslint = function(is_node_repo)
		if not is_node_repo then
			return
		end

		vim.lsp.config("eslint", {})
		vim.lsp.enable("eslint")
	end,
	biome = function(is_node_repo)
		if not is_node_repo then
			return
		end

		vim.lsp.config("biome", {})
		vim.lsp.enable("biome")
	end,
	denols = function(is_node_repo)
		local opts = {}
		-- local node_root_dir = lspconfig.util.root_pattern("package.json")

		if is_node_repo then
			return
		end

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
	end,
}

local node_root_dir = lspconfig.util.root_pattern("package.json")
local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0)) ~= nil

for _, server in pairs(current_manual_enable_servers) do
	manual_config[server](is_node_repo)
end

if vim.fn.executable("deno") then
	manual_config["denols"](is_node_repo)
end

if vim.fn.executable("serve-d") and vim.fn.executable("dmd") then
	manual_config["serve_d"]()
end
-- }}}
