-- lua_source {{{
require("nvim-treesitter.configs").setup({
	ensure_installed = {
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
	},
	sync_install = false,
	autotag = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

-- require 'nvim-treesitter.install'.compilers = { "gcc", "zig" }
-- }}}
