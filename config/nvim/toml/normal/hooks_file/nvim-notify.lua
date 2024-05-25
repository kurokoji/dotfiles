-- lua_source {{{
local notify = require("notify")

notify.setup({
	top_down = false,
})

vim.notify = notify

vim.g["dein#enable_notification"] = true
-- }}}
