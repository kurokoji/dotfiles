-- lua_source {{{
local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.rubocop.with({
			command = "bundle",
			args = { "exec", "rubocop", "-a", "--server", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" },
		}),
		null_ls.builtins.diagnostics.rubocop.with({
			command = "bundle",
			args = { "exec", "rubocop", "-f", "json", "--force-exclusion", "--stdin", "$FILENAME" },
		}),
	},
})
-- }}}
