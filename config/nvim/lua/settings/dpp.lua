-- dpp.vim {{{
local fn = vim.fn
local uv = vim.loop

-- $CACHE (~/.cache)
local CACHE = fn.expand("~/.cache")
if fn.isdirectory(CACHE) == 0 then
	fn.mkdir(CACHE, "p")
end
vim.env.CACHE = CACHE

local dpp_base = fn.expand(CACHE .. "/dpp")
local dpp_dir = fn.expand(dpp_base .. "/repos/github.com/Shougo/dpp.vim")
local denops_dir = fn.expand(dpp_base .. "/repos/github.com/vim-denops/denops.vim")

-- Extensions to auto-clone and add to rtp (same as your Vimscript)
local dpp_exts = {
	"Shougo/dpp-ext-installer",
	"Shougo/dpp-ext-lazy",
	"Shougo/dpp-ext-toml",
	"Shougo/dpp-protocol-git",
}

-- Git clone helper
local function git_clone(url, dest)
	if uv.fs_stat(dest) then
		return
	end
	vim.notify("install " .. url, vim.log.levels.WARN)
	fn.system({ "git", "clone", url, dest })
end

-- Ensure dpp.vim itself exists, then add to rtp
if fn.isdirectory(dpp_dir) == 0 then
	git_clone("https://github.com/Shougo/dpp.vim", dpp_dir)
end

vim.opt.runtimepath:prepend(dpp_dir)

-- Ensure extensions exist
for _, ext in ipairs(dpp_exts) do
	local dest = fn.expand(dpp_base .. "/repos/github.com/" .. ext)
	if fn.isdirectory(dest) == 0 then
		git_clone("https://github.com/" .. ext, dest)
	end
end

local source = debug.getinfo(1, "S").source
if source:sub(1, 1) == "@" then
	source = source:sub(2)
end
local BASE_DIR = vim.fn.fnamemodify(vim.env.MYVIMRC, ":h")
-- Paths used by your config files
vim.env.BASE_DIR = BASE_DIR
vim.env.NORMAL_TOML_DIR = fn.expand(BASE_DIR .. "/toml/normal")
vim.env.LAZY_TOML_DIR = fn.expand(BASE_DIR .. "/toml/lazy")
vim.env.DPP_CONFIG = fn.expand(BASE_DIR .. "/dpp.ts")

package.path = package.path .. ";" .. BASE_DIR .. "/lua/?.lua"

-- Load dpp or make state (Lua API per README)
local ok, dpp = pcall(require, "dpp")

if not ok then
	-- Fallback: try Vim function require through rtp
	dpp = nil
	vim.notify("Failed to load dpp module.", vim.log.levels.WARN)
end

local function add_to_rtp(path)
	vim.opt.runtimepath:prepend(path)
end

local function add_exts_to_rtp()
	for _, ext in ipairs(dpp_exts) do
		add_to_rtp(fn.expand(dpp_base .. "/repos/github.com/" .. ext))
	end
end

-- If we need to (re)generate, we must add denops + extensions to rtp
if dpp and dpp.load_state(dpp_base) then
	if fn.isdirectory(denops_dir) == 0 then
		git_clone("https://github.com/vim-denops/denops.vim", denops_dir)
	end
	add_to_rtp(denops_dir)
	add_exts_to_rtp()

	vim.api.nvim_create_autocmd("User", {
		pattern = "DenopsReady",
		callback = function()
			vim.notify("dpp load_state() is failed", vim.log.levels.WARN)
			dpp.make_state(dpp_base, vim.env.DPP_CONFIG)
		end,
	})
else
	-- State loaded ok: wire up watchers like your original
	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = { "*.lua", "*.vim", "*.toml", "*.ts", "init.vim", "init.lua" },
		callback = function()
			pcall(function()
				vim.fn["dpp#check_files"]()
			end)
		end,
	})
	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = { "*.toml" },
		callback = function()
			local not_installed = vim.fn["dpp#sync_ext_action"]("installer", "getNotInstalled")
			if type(not_installed) == "table" and #not_installed > 0 then
				vim.fn["dpp#async_ext_action"]("installer", "install")
			end
		end,
	})
end

vim.api.nvim_create_autocmd("User", {
	pattern = "Dpp:makeStatePost",
	callback = function()
		vim.notify("dpp make_state() is done", vim.log.levels.WARN)
	end,
})

-- 自動でdpp.make_state
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "*.lua", "*.vim", "*.toml", "*.ts", "vimrc", ".vimrc" },
	callback = function(_)
		if dpp and not vim.tbl_isempty(dpp.check_files()) then
			dpp.make_state()
		end
	end,
})

-- Commands: DppInstall / DppUpdate
vim.api.nvim_create_user_command("DppInstall", function()
	vim.fn["dpp#async_ext_action"]("installer", "install")
end, {})
vim.api.nvim_create_user_command("DppUpdate", function()
	vim.fn["dpp#async_ext_action"]("installer", "update")
end, {})

-- }}}
