-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local opts = require("eth-p.opts")
local utils = require("eth-p.utils")
return {

	-- barbar
	--
	-- Repo: https://github.com/romgrk/barbar.nvim
	-- Docs: https://github.com/romgrk/barbar.nvim
	--
	-- This transforms the vim status line into something more modern.
	--
	{
		"romgrk/barbar.nvim",
		version = "^1.0.0",
		dependencies = utils.optional_deps {
			opts.ui.nerdfonts and "nvim-tree/nvim-web-devicons",
		},

		cond = opts.ui.tabline.enabled,
		lazy = false,
		priority = 900,

		init = function()
			vim.g.barbar_auto_setup = false
		end,

		opts = {
			animation = false,
			auto_hide = 0, -- 1,
			icons = {
				filetype = {
					enabled = opts.ui.nerdfonts,
				},
			},

			sidebar_filetypes = {
				["neo-tree"] = { event = "WinClosed" }, -- neo-tree sidebar
			},
		},
	},
}
