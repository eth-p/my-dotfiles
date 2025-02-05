-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local utils = require("eth-p.utils")

--============================================================================--
--=== Default Options ===--

defaults = {
	-- ui describes options related to the user interface
	ui = {
		colorscheme = "monokai-pro", -- interface/editor colorscheme
		focus_dimming = true, -- dim when neovim not focused
		transparent_background = true, -- use transparent background
		nerdfont = false, -- nerdfonts enabled
	},

	keymap = {
		help = true, -- display keymap
		preserve = false, -- preserve the builtin keymap
	},

	-- editor decsribes options related to editing
	editor = {
		fold = {
			enabled = true,
		},
	},

	-- gutter describes options related to the sidebar
	gutter = {
		numbers = {
			enabled = true,
			width = 2,
		},
		fold = {
			enabled = false,
			width = 3,
		},
	},

	-- commands describes options related to commands
	commands = {
		prefix = "",
	},
}

--============================================================================--
--=== User Options ===--

user = {}
merged = vim.deepcopy(defaults)

--============================================================================--
--=== Exports ===--

return setmetatable({}, {
	__index = function(_, k)
		return merged[k]
	end,

	__newindex = function(_, k, v)
		user = vim.tbl_deep_extend("force", {}, user, { [k] = v })
		merged = vim.tbl_deep_extend("force", {}, defaults, user)
	end,

	__call = function(_, new)
		user = vim.deepcopy(new, true)
		merged = vim.tbl_deep_extend("force", {}, defaults, user)
	end,
})
