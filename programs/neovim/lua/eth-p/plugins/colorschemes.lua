-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local opts = require("eth-p.opts")
local theme = require("eth-p.theme")
local utils = require("eth-p.utils")
return {

	-- Monokai-Pro
	--
	-- Repo: https://github.com/loctvl842/monokai-pro.nvim
	-- Docs: https://github.com/loctvl842/monokai-pro.nvim?tab=readme-ov-file#-configuration
	{
		"loctvl842/monokai-pro.nvim",
		lazy = false,
		priority = 1000,

		opts = {
			transparent_background = opts.ui.transparent_background,
			background_clear = utils.ternary(opts.ui.focus_dimming, {
				"neo-tree",
			}, {}),
		},

		config = function(self)
			require("monokai-pro").setup(self.opts)
			require("monokai-pro.theme").setup()

			local palette = require("monokai-pro.colorscheme.palette.pro")
			local gutter_bg = "#353337"
			local gutter_bg_uf = "#252227"

			local telescope_his = utils.ternary(opts.ui.focus_dimming, {
				bg = "#2d2a2e",
				border_fg = "#403e41",
			}, {
				bg = "#403e41",
				border_fg = "#646166",
			})

			-- Register the theme.
			theme.register {
				colorscheme = "monokai-pro",
				lualine = "monokai-pro",
				overrides = {
					general = {
						LineNr = {
							bg = gutter_bg,
							fg = "#999999",
							ctermbg = 235,
							ctermfg = 245,
						},
						FoldColumn = {
							bg = gutter_bg,
							fg = "#777777",
							ctermbg = 235,
							ctermfg = 243,
						},
						SignColumn = {
							bg = gutter_bg,
							fg = "#777777",
							ctermbg = 235,
							ctermfg = 243,
						},
						CursorLineNr = {
							bg = gutter_bg,
							fg = "#ffd866",
							ctermbg = 236,
							ctermfg = 220,
						},
						CursorLineFold = {
							bg = gutter_bg,
							fg = "#777777",
							ctermbg = 236,
							ctermfg = 243,
						},

						-- Telescope
						TelescopeResultsNormal = {
							bg = telescope_his.bg,
						},
						TelescopePreviewNormal = {
							bg = telescope_his.bg,
						},
						TelescopePromptNormal = {
							bg = telescope_his.bg,
						},
						TelescopeNormal = {
							bg = telescope_his.bg,
						},
						TelescopePromptPrefix = {
							bg = telescope_his.bg,
							fg = "#78dce8",
						},
						TelescopeResultsBorder = {
							bg = telescope_his.bg,
							fg = telescope_his.border_fg,
						},
						TelescopePreviewBorder = {
							bg = telescope_his.bg,
							fg = telescope_his.border_fg,
						},
						TelescopePromptBorder = {
							bg = telescope_his.bg,
							fg = telescope_his.border_fg,
						},
						TelescopeBorder = {
							bg = telescope_his.bg,
							fg = telescope_his.border_fg,
						},

						-- Listchars
						NonText = { fg = "#525152", ctermfg = 234 },
						Whitespace = { fg = "#525152", ctermfg = 234 },
						TrailingWhitespace = { bg = "#5f1f78", ctermbg = 90 },

						-- Columns
						CursorColumn = { bg = "#353333", ctermbg = 235 },
						ColorColumn = { bg = "#533333", ctermbg = 235 },

						-- Git
						GitSignsAdd = { bg = gutter_bg, fg = palette.accent4 },
						GitSignsChange = {
							bg = gutter_bg,
							fg = palette.accent6,
						},
						GitSignsDelete = {
							bg = gutter_bg,
							fg = palette.accent1,
						},
					},
				},
			}
		end,
	},

	-- Catppuccin
	--
	-- Repo: https://github.com/catppuccin/nvim
	-- Docs: https://github.com/catppuccin/nvim
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
	},
}
