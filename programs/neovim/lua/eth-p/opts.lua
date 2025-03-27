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
		nerdfonts = false, -- nerdfonts enabled

		tabline = {
			enabled = true,
		},

		sidebar = {
			ignores_focus_dimming = false,
		},
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
		indents = {
			detect = true,

			guides_always = false,
			guides_on_filetypes = {
				"yaml",
				"nix",
			},
		},
		whitespace = {
			show_always = false,

			show_on_highlight = true,
			show_on_highlight_excludes_filetypes = {},

			show_on_filetypes = {
				"make",
			},

			chars = {
				tab = "→",
				space = nil,
				lead = "•",
				trail = "•",
				eol = nil,
				nbsp = "␣",
			},
		},
		cursor = {
			keep_centered = true,
		},
	},

	-- integration describes integrations with external tools
	integration = {
		git = true,
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
