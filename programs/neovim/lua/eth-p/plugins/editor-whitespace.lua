-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local opts = require("eth-p.opts")
local utils = require("eth-p.utils")
local listchars_map = opts.editor.whitespace.chars

local function not_empty(v)
	if v == nil or v == "" or v == " " then
		return nil
	else
		return v
	end
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
			tab_char = not_empty(listchars_map.tab) or " ",
			nl_char = not_empty(listchars_map.eol) or " ",
			cr_char = " ",
			nbsp_char = not_empty(listchars_map.nbsp) or "",
			space_char = (not_empty(listchars_map.space) or not_empty(
				listchars_map.lead
			) or not_empty(listchars_map.trail) or " "),

			excluded = {
				filetypes = vim.list_extend({
					"neo-tree",
				}, opts.editor.whitespace.show_on_highlight_excludes_filetypes),
			},
		},

		init = function(self)
			local augroup = utils.augroup("editor-whitespace.visual-whitespace")
			local function regen_highlight()
				local visual_hl = vim.api.nvim_get_hl(0, { name = "Visual" })
				local nontext_hl = vim.api.nvim_get_hl(0, { name = "NonText" })

				vim.api.nvim_set_hl(0, "VisualNonText", {
					fg = nontext_hl.fg,
					ctermfg = nontext_hl.ctermfg,
					bg = visual_hl.bg,
					ctermbg = visual_hl.ctermbg,
				})
			end

			-- Generate the VisualNonText highlight when the colorscheme changes.
			regen_highlight()
			vim.api.nvim_create_autocmd("ColorScheme", {
				group = augroup,
				pattern = "*",
				callback = regen_highlight,
			})
		end,
	},
}
