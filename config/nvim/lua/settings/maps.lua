-- mapping {{{
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Terminal mode
map("t", "<Esc>", [[<C-\><C-n>]], opts)
map("t", "<C-[>", [[<C-\><C-n>]], opts)

-- Normal mode
map("n", ";", ":", { noremap = true })
map("n", "x", '"_x', opts)

map("n", "ss", "<Cmd>sp<CR>", opts)
map("n", "sv", "<Cmd>vs<CR>", opts)

map("n", ">", ">>", opts)
map("n", "<", "<<", opts)
map("x", ">", ">gv", opts)
map("x", "<", "<gv", opts)

-- Tabs
-- map('n', 'sn', 'gt', opts)
-- map('n', 'sp', 'gT', opts)
map("n", "<Tab>", "gt", opts)
map("n", "<S-Tab>", "gT", opts)
map("n", "st", "<Cmd>tabnew<CR>", opts)

-- Windows
map("n", "sh", "<C-w>h", opts)
map("n", "sj", "<C-w>j", opts)
map("n", "sk", "<C-w>k", opts)
map("n", "sl", "<C-w>l", opts)

-- Leader
vim.g.mapleader = " "

-- Command-line mode
map("c", "<C-a>", "<Home>", opts)
map("c", "<C-h>", "<Left>", opts)
map("c", "<C-d>", "<Del>", opts)
map("c", "<C-e>", "<End>", opts)
map("c", "<C-l>", "<Right>", opts)
map("c", "<C-n>", "<Down>", opts)
map("c", "<C-p>", "<Up>", opts)
map("c", "<C-y>", "<C-r>*", opts)
map("c", "<C-g>", "<C-c>", opts)

-- Clipboard copy (visual)
map("x", "<C-y>", '"+y', opts)

vim.g.no_plugin_maps = true

-- }}}
