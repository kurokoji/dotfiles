-- lua_source {{{

nvim_treesitter = require("nvim-treesitter")
nvim_treesitter.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

nvim_treesitter.install({
	"python",
	"cpp",
	"go",
	"typescript",
	"vim",
	"toml",
	"rust",
	"html",
	"bash",
	"javascript",
	"lua",
	"tsx",
	"haskell",
	"markdown",
	"ruby",
	"embedded_template",
})

-- require 'nvim-treesitter.install'.compilers = { "gcc", "zig" }
-- }}}
