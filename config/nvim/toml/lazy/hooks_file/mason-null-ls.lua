-- lua_source {{{
require("mason-null-ls").setup({
	ensure_installed = { "prettier", "stylua", "black" },
	automatic_setup = true,
	handlers = {},
})
--  }}}
