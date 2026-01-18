vim.opt.backspace = { "indent", "eol", "start" }

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true
vim.opt.incsearch = true

-- lualine shows mode
vim.opt.showmode = false

-- disable mouse
vim.opt.mouse = ""

vim.opt.exrc = true
vim.opt.secure = true
vim.opt.writebackup = true
vim.opt.infercase = true
vim.opt.autoread = true
vim.opt.wrap = false
vim.opt.foldmethod = "marker"

vim.opt.fileformats = { "unix", "dos", "mac" }
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "iso-2022-jp", "cp932", "sjis", "euc-jp" }

-- pumblend/winblend (disabled by default, as in your config)
-- if vim.fn.has('nvim') == 1 then
--   vim.opt.pumblend = 20
--   vim.opt.winblend = 20
-- end

-- Windows shell (PowerShell)
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
	local shell = fn.executable("pwsh") == 1 and "pwsh" or "powershell"
	vim.o.shell = shell
	vim.o.shellcmdflag =
		"-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';Remove-Alias -Force -ErrorAction SilentlyContinue tee;"
	vim.o.shellredir = '2>&1 | %%%%{ "$_" } | Out-File %s; exit $LastExitCode'
	vim.o.shellpipe = '2>&1 | %%%%{ "$_" } | tee %s; exit $LastExitCode'
	vim.o.shellquote = ""
	vim.o.shellxquote = ""
end

if vim.fn.has("syntax") == 1 then
	vim.cmd("syntax on")
end

vim.opt.title = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.list = true
-- vim.opt.ambiwidth = 'double'
-- Alternative listchars examples:
-- vim.opt.listchars = { tab = '>-', eol = '¬', nbsp = '%', trail = '·', extends = '»', precedes = '«' }
vim.opt.listchars = "tab:⇥⇥,eol:↵,nbsp:⍽,trail:·,extends:»,precedes:«"

-- Show matching pairs
vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.matchpairs:append("<:>")

vim.opt.laststatus = 2
vim.opt.showtabline = 2
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.wildmenu = true
vim.opt.wildmode = "full"

vim.opt.background = "light"
vim.opt.termguicolors = true
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "dOperator", { fg = "#fb4934" })
	end,
})

-- Colorscheme (ensure it's installed)
-- vim.cmd.colorscheme "melange"
vim.cmd.colorscheme "sakuracream"

local use_neovide = vim.g.neovide ~= nil
local use_gui = use_neovide or vim.fn.has("gui_running") == 1

-- Transparency toggler (disabled by default)
local function enable_transparent()
	if not use_gui then
		for _, grp in ipairs({ "Normal", "NormalNC", "NormalFloat", "WinBar", "WinBarNC", "Special" }) do
			vim.api.nvim_set_hl(0, grp, { ctermbg = "NONE", bg = "NONE" })
		end
	elseif use_neovide then
		vim.g.neovide_transparency = 0.95
	end
end
-- enable_transparent()

-- Split behavior
vim.opt.splitbelow = true

-- Indentation
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.ttyfast = true

-- GUI font
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
	vim.opt.guifont = "Moralerspace Xenon NF:h8"
else
	vim.opt.guifont = "Moralerspace Xenon NF:h14"
end

vim.g.tex_conceal = ""

-------------------------------------------------------------
-- Cursor style
-------------------------------------------------------------
vim.opt.guicursor = "n-v-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"
