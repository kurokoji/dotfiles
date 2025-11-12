-- Filetype plugins/indent
vim.cmd("filetype plugin indent on")

-------------------------------------------------------------
-- FileTypeConfig augroup
-------------------------------------------------------------
local ft = vim.api.nvim_create_augroup("FileTypeConfig", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
	end,
	group = ft,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function()
		vim.bo.softtabstop = 4
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
	end,
	group = ft,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	callback = function()
		vim.bo.softtabstop = 2
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.cindent = true
		vim.bo.cinoptions = (vim.bo.cinoptions or "") .. ":0,g0"
	end,
	group = ft,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function()
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.expandtab = false
	end,
	group = ft,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.expandtab = false
	end,
	group = ft,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "d",
	callback = function()
		vim.bo.softtabstop = 2
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.cindent = true
		vim.bo.cinoptions = (vim.bo.cinoptions or "") .. ":0,g0"
	end,
	group = ft,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "html",
	callback = function()
		vim.bo.indentexpr = ""
	end,
	group = ft,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "json",
	callback = function()
		-- highlight // comments
		vim.cmd([[syntax match Comment +\/\/.\+$+]])
	end,
	group = ft,
})

-------------------------------------------------------------
-- MyFileType augroup (custom filetype detection)
-------------------------------------------------------------
local myft = vim.api.nvim_create_augroup("MyFileType", { clear = true })
vim.api.nvim_create_autocmd(
	{ "BufNewFile", "BufRead" },
	{ pattern = "*.bigquery", command = "setfiletype sql", group = myft }
)
vim.api.nvim_create_autocmd(
	{ "BufNewFile", "BufRead" },
	{ pattern = { "*.rbi", "*.schema", "Schemafile" }, command = "setfiletype ruby", group = myft }
)
vim.api.nvim_create_autocmd(
	{ "BufNewFile", "BufRead" },
	{ pattern = { "*.anm2", "*obj2" }, command = "setfiletype lua", group = myft }
)
