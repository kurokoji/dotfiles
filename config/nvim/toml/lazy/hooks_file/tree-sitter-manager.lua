-- lua_source {{{
require("tree-sitter-manager").setup({
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
})
-- }}}
