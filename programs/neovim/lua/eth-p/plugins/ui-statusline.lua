-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local opts = require("eth-p.opts")
local theme = require("eth-p.theme")
local utils = require("eth-p.utils")
return {

	-- lualine
	--
	-- Repo: https://github.com/nvim-lualine/lualine.nvim
	-- Docs: https://github.com/nvim-lualine/lualine.nvim/wiki
	--
	-- This transforms the vim status line into something more modern.
	--
	{
		"nvim-lualine/lualine.nvim",
		dependencies = utils.optional_deps {
			opts.ui.nerdfont and "nvim-tree/nvim-web-devicons",
		},

		lazy = false,
		priority = 900,

		opts = {
			options = {
				theme = "auto",
				icons_enabled = opts.ui.nerdfont,
			},
		},

		init = function(self)
			local augroup = utils.augroup("ui-statusline.lualine")

			-- Reapply the theme when the colorscheme changes.
			vim.api.nvim_create_autocmd("ColorScheme", {
				group = augroup,
				pattern = "*",
				callback = function()
					require("lualine").setup(
						vim.tbl_deep_extend("force", {}, self.opts, {
							theme = theme.get().lualine or "auto",
						})
					)
				end,
			})
		end,
	},
}
