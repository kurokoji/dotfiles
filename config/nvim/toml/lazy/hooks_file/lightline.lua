-- lua_add {{{
local g = vim.g

local mode_map = {
	n = "N",
	i = "I",
	R = "R",
	v = "V",
	V = "VL",
	["<C-v>"] = "VB",
	c = "C",
	s = "S",
	S = "SL",
	["<C-s>"] = "SB",
	t = "T",
}

local separator = {
	left = "",
	right = "",
}

local subseparator = {
	left = "",
	right = "",
}

g.lightline = {
	colorscheme = "tokyonight",
	mode_map = mode_map,
	separator = separator,
	subseparator = subseparator,
}

-- }}}
