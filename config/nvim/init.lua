-- mapping {{{ 
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Terminal mode
map('t', '<Esc>', [[<C-\><C-n>]], opts)
map('t', '<C-[>', [[<C-\><C-n>]], opts)

-- Normal mode
map('n', ';', ':', { noremap = true })
map('n', 'x', '"_x', opts)

map('n', 'ss', '<Cmd>sp<CR>', opts)
map('n', 'sv', '<Cmd>vs<CR>', opts)

map('n', '>', '>>', opts)
map('n', '<', '<<', opts)
map('x', '>', '>gv', opts)
map('x', '<', '<gv', opts)

-- Tabs
-- map('n', 'sn', 'gt', opts)
-- map('n', 'sp', 'gT', opts)
map('n', '<Tab>', 'gt', opts)
map('n', '<S-Tab>', 'gT', opts)
map('n', 'st', '<Cmd>tabnew<CR>', opts)

-- Windows
map('n', 'sh', '<C-w>h', opts)
map('n', 'sj', '<C-w>j', opts)
map('n', 'sk', '<C-w>k', opts)
map('n', 'sl', '<C-w>l', opts)

-- Leader
vim.g.mapleader = ' '

-- Command-line mode
map('c', '<C-a>', '<Home>', opts)
map('c', '<C-h>', '<Left>', opts)
map('c', '<C-d>', '<Del>', opts)
map('c', '<C-e>', '<End>', opts)
map('c', '<C-l>', '<Right>', opts)
map('c', '<C-n>', '<Down>', opts)
map('c', '<C-p>', '<Up>', opts)
map('c', '<C-y>', '<C-r>*', opts)
map('c', '<C-g>', '<C-c>', opts)

-- Clipboard copy (visual)
map('x', '<C-y>', '"+y', opts)

vim.g.no_plugin_maps = true

-- }}}

-- dpp.vim {{{
local fn = vim.fn
local uv = vim.loop

-- $CACHE (~/.cache)
local CACHE = fn.expand('~/.cache')
if fn.isdirectory(CACHE) == 0 then
  fn.mkdir(CACHE, 'p')
end
vim.env.CACHE = CACHE

local dpp_base = fn.expand(CACHE .. '/dpp')
local dpp_dir  = fn.expand(dpp_base .. '/repos/github.com/Shougo/dpp.vim')
local denops_dir = fn.expand(dpp_base .. '/repos/github.com/vim-denops/denops.vim')

-- Extensions to auto-clone and add to rtp (same as your Vimscript)
local dpp_exts = {
  'Shougo/dpp-ext-installer',
  'Shougo/dpp-ext-lazy',
  'Shougo/dpp-ext-toml',
  'Shougo/dpp-protocol-git',
}

-- Git clone helper
local function git_clone(url, dest)
  if uv.fs_stat(dest) then return end
  vim.notify('install ' .. url, vim.log.levels.WARN)
  fn.system({ 'git', 'clone', url, dest })
end

-- Ensure dpp.vim itself exists, then add to rtp
if fn.isdirectory(dpp_dir) == 0 then
  git_clone('https://github.com/Shougo/dpp.vim', dpp_dir)
end
vim.opt.runtimepath:prepend(fn.substitute(fn.fnamemodify(dpp_dir, ':p'), [[[/\]$]], '', ''))

-- Ensure extensions exist
for _, ext in ipairs(dpp_exts) do
  local dest = fn.expand(dpp_base .. '/repos/github.com/' .. ext)
  if fn.isdirectory(dest) == 0 then
    git_clone('https://github.com/' .. ext, dest)
  end
end

local source = debug.getinfo(1, "S").source
if source:sub(1,1) == '@' then source = source:sub(2) end
local BASE_DIR = vim.fn.fnamemodify(source, ":h")
-- Paths used by your config files
vim.env.BASE_DIR = BASE_DIR
vim.env.NORMAL_TOML_DIR = fn.expand(BASE_DIR .. '/toml/normal')
vim.env.LAZY_TOML_DIR   = fn.expand(BASE_DIR .. '/toml/lazy')
vim.env.DPP_CONFIG      = fn.expand(BASE_DIR .. '/dpp.ts')

-- Load dpp or make state (Lua API per README)
local ok, dpp = pcall(require, 'dpp')
if not ok then
  -- Fallback: try Vim function require through rtp
  dpp = nil
end

local function add_to_rtp(path)
  vim.opt.runtimepath:prepend(path)
end

local function add_exts_to_rtp()
  for _, ext in ipairs(dpp_exts) do
    add_to_rtp(fn.expand(dpp_base .. '/repos/github.com/' .. ext))
  end
end

-- If we need to (re)generate, we must add denops + extensions to rtp
if dpp and dpp.load_state(dpp_base) then
  if fn.isdirectory(denops_dir) == 0 then
    git_clone('https://github.com/vim-denops/denops.vim', denops_dir)
  end
  add_to_rtp(fn.substitute(fn.fnamemodify(denops_dir, ':p'), [[[/\]$]], '', ''))
  add_exts_to_rtp()

  vim.api.nvim_create_autocmd('User', {
    pattern = 'DenopsReady',
    callback = function()
      vim.notify('dpp load_state() is failed', vim.log.levels.WARN)
      dpp.make_state(dpp_base, vim.env.DPP_CONFIG)
    end,
  })
else
  -- State loaded ok: wire up watchers like your original
  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = { '*.lua', '*.vim', '*.toml', '*.ts', 'init.vim', 'init.lua' },
    callback = function()
      pcall(function()
        vim.fn['dpp#check_files']()
      end)
    end,
  })
  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = { '*.toml' },
    callback = function()
      local not_installed = vim.fn['dpp#sync_ext_action']('installer', 'getNotInstalled')
      if type(not_installed) == 'table' and #not_installed > 0 then
        vim.fn['dpp#async_ext_action']('installer', 'install')
      end
    end,
  })
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'Dpp:makeStatePost',
  callback = function()
    vim.notify('dpp make_state() is done', vim.log.levels.WARN)
  end,
})

-- Commands: DppInstall / DppUpdate
vim.api.nvim_create_user_command('DppInstall', function()
  vim.fn['dpp#async_ext_action']('installer', 'install')
end, {})
vim.api.nvim_create_user_command('DppUpdate', function()
  vim.fn['dpp#async_ext_action']('installer', 'update')
end, {})

-- }}}

require("lsp_settings")

vim.opt.backspace = { 'indent', 'eol', 'start' }

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true
vim.opt.incsearch = true

-- lualine shows mode
vim.opt.showmode = false

-- disable mouse
vim.opt.mouse = ''

vim.opt.exrc = true
vim.opt.secure = true
vim.opt.writebackup = true
vim.opt.infercase = true
vim.opt.autoread = true
vim.opt.wrap = false
vim.opt.foldmethod = 'marker'

vim.opt.fileformats = { 'unix', 'dos', 'mac' }
vim.opt.encoding = 'utf-8'
vim.opt.fileencodings = { 'utf-8', 'iso-2022-jp', 'cp932', 'sjis', 'euc-jp' }

-- pumblend/winblend (disabled by default, as in your config)
-- if vim.fn.has('nvim') == 1 then
--   vim.opt.pumblend = 20
--   vim.opt.winblend = 20
-- end

-- Windows shell (PowerShell)
if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
  local shell = fn.executable('pwsh') == 1 and 'pwsh' or 'powershell'
  vim.o.shell = shell
  vim.o.shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[\'Out-File:Encoding\']=\'utf8\';Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
  vim.o.shellredir = '2>&1 | %%%%{ "$_" } | Out-File %s; exit $LastExitCode'
  vim.o.shellpipe  = '2>&1 | %%%%{ "$_" } | tee %s; exit $LastExitCode'
  vim.o.shellquote = ''
  vim.o.shellxquote = ''
end

if vim.fn.has('syntax') == 1 then
  vim.cmd('syntax on')
end

vim.opt.title = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.signcolumn = 'yes'
vim.opt.list = true
-- vim.opt.ambiwidth = 'double'
-- Alternative listchars examples:
-- vim.opt.listchars = { tab = '>-', eol = '¬', nbsp = '%', trail = '·', extends = '»', precedes = '«' }
vim.opt.listchars = 'tab:⇥⇥,eol:↵,nbsp:⍽,trail:·,extends:»,precedes:«'

-- Show matching pairs
vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.matchpairs:append('<:>')

vim.opt.laststatus = 2
vim.opt.showtabline = 2
vim.opt.completeopt = { 'menuone', 'noselect' }
vim.opt.wildmenu = true
vim.opt.wildmode = 'full'

vim.opt.background = 'light'
vim.opt.termguicolors = true
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'dOperator', { fg = '#fb4934' })
  end,
})

-- Colorscheme (ensure it's installed)
pcall(vim.cmd, 'colorscheme melange')

local use_neovide = vim.g.neovide ~= nil
local use_gui = use_neovide or vim.fn.has('gui_running') == 1

-- Transparency toggler (disabled by default)
local function enable_transparent()
  if not use_gui then
    for _, grp in ipairs({ 'Normal', 'NormalNC', 'NormalFloat', 'WinBar', 'WinBarNC', 'Special' }) do
      vim.api.nvim_set_hl(0, grp, { ctermbg = 'NONE', bg = 'NONE' })
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
if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
  vim.opt.guifont = 'Moralerspace Xenon NF:h8'
else
  vim.opt.guifont = 'Moralerspace Xenon NF:h14'
end

vim.g.tex_conceal = ''

-- Filetype plugins/indent
vim.cmd('filetype plugin indent on')

-------------------------------------------------------------
-- FileTypeConfig augroup
-------------------------------------------------------------
local ft = vim.api.nvim_create_augroup('FileTypeConfig', { clear = true })
vim.api.nvim_create_autocmd('FileType', { pattern = 'python', callback = function()
  vim.bo.tabstop = 4; vim.bo.shiftwidth = 4
end, group = ft })
vim.api.nvim_create_autocmd('FileType', { pattern = 'java', callback = function()
  vim.bo.softtabstop = 4; vim.bo.tabstop = 4; vim.bo.shiftwidth = 4
end, group = ft })
vim.api.nvim_create_autocmd('FileType', { pattern = { 'c', 'cpp' }, callback = function()
  vim.bo.softtabstop = 2; vim.bo.tabstop = 2; vim.bo.shiftwidth = 2
  vim.bo.cindent = true; vim.bo.cinoptions = (vim.bo.cinoptions or '') .. ':0,g0'
end, group = ft })
vim.api.nvim_create_autocmd('FileType', { pattern = 'go', callback = function()
  vim.bo.tabstop = 4; vim.bo.shiftwidth = 4; vim.bo.expandtab = false
end, group = ft })
vim.api.nvim_create_autocmd('FileType', { pattern = 'lua', callback = function()
  vim.bo.tabstop = 2; vim.bo.shiftwidth = 2; vim.bo.expandtab = false
end, group = ft })
vim.api.nvim_create_autocmd('FileType', { pattern = 'd', callback = function()
  vim.bo.softtabstop = 2; vim.bo.tabstop = 2; vim.bo.shiftwidth = 2
  vim.bo.cindent = true; vim.bo.cinoptions = (vim.bo.cinoptions or '') .. ':0,g0'
end, group = ft })
vim.api.nvim_create_autocmd('FileType', { pattern = 'html', callback = function()
  vim.bo.indentexpr = ''
end, group = ft })
vim.api.nvim_create_autocmd('FileType', { pattern = 'json', callback = function()
  -- highlight // comments
  vim.cmd([[syntax match Comment +\/\/.\+$+]])
end, group = ft })

-------------------------------------------------------------
-- MyFileType augroup (custom filetype detection)
-------------------------------------------------------------
local myft = vim.api.nvim_create_augroup('MyFileType', { clear = true })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, { pattern = '*.bigquery', command = 'setfiletype sql', group = myft })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, { pattern = { '*.rbi', '*.schema', 'Schemafile' }, command = 'setfiletype ruby', group = myft })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, { pattern = { '*.anm2', '*obj2' }, command = 'setfiletype lua', group = myft })

-------------------------------------------------------------
-- Cursor style
-------------------------------------------------------------
vim.opt.guicursor = 'n-v-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor'

-------------------------------------------------------------
-- CloseAllFloatingWindows() and command
-------------------------------------------------------------
local function CloseAllFloatingWindows()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local cfg = vim.api.nvim_win_get_config(win)
    if cfg and cfg.relative ~= '' then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
end
vim.api.nvim_create_user_command('CloseAllFloatingWindows', CloseAllFloatingWindows, {})

