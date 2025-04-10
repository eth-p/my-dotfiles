-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local opts = require("eth-p.opts")
local theme = require("eth-p.theme")
local utils = require("eth-p.utils")
local listchars_map = opts.editor.whitespace.chars

local function first_not_empty(...)
	local args = { ... }
	local n = select("#", ...)
	for i = 1, n do
		local val = args[i]
		if val ~= nil and val ~= "" and val ~= " " then
			return val
		end
	end

	return args[#args]
end

return {

	-- visual-whitespace
	--
	-- Repo: https://github.com/mcauley-penney/visual-whitespace.nvim
	-- Docs: https://github.com/mcauley-penney/visual-whitespace.nvim
	--
	-- Shows whitespace inside text highlighted under visual mode.
	--
	{
		"mcauley-penney/visual-whitespace.nvim",

		lazy = true,
		event = {
			"ModeChanged",
		},
		cmds = {
			"ToggleVisualWhitespace",
		},

		opts = {
			enabled = opts.editor.whitespace.show_on_highlight,
			tab_char = first_not_empty(listchars_map.tab, " "),
			nl_char = first_not_empty(listchars_map.eol, " "),
			cr_char = " ",
			nbsp_char = first_not_empty(listchars_map.nbsp, ""),
			space_char = first_not_empty(
				listchars_map.space,
				listchars_map.lead,
				listchars_map.trail,
				" "
			),

			excluded = {
				filetypes = vim.list_extend(
					{
						"neo-tree",
						"TelescopePrompt",
					},
					utils.create_enablelist(
						opts.editor.whitespace.show_on_highlight_excludes_filetypes
					)
				),
			},
		},

		init = function(self)
			theme.addHighlights {
				VisualNonText = {
					link = {
						fg = "NonText",
						ctermfg = "NonText",
						bg = "Visual",
						ctermbg = "Visual",
					},
				},
			}
		end,
	},

	-- whitespace.nvim
	--
	-- Repo: https://github.com/johnfrankmorgan/whitespace.nvim
	-- Docs: https://github.com/johnfrankmorgan/whitespace.nvim
	--
	-- Highlights trailing whitespace.
	--
	{
		"johnfrankmorgan/whitespace.nvim",

		cond = opts.editor.whitespace.show_trailing,
		lazy = true,
		event = {
			"BufNewFile",
			"BufRead",
			"StdinReadPost",
		},

		opts = {
			highlight = "TrailingWhitespace",
			ignored_filetypes = vim.list_extend(
				{
					"TelescopePrompt",
				},
				utils.create_enablelist(
					opts.editor.whitespace.show_trailing_excludes_filetypes
				)
			),
		},

		init = function()
			theme.addHighlights {
				TrailingWhitespace = {
					default = true,
					link = "ExtraWhitespace",
				},
				ExtraWhitespace = { default = true, link = "DiffDelete" },
			}
		end,
	},
}
