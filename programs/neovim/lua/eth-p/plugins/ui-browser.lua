-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local opts = require("eth-p.opts")
return {

	-- ranger.nvim
	--
	-- Repo: https://github.com/kelly-lin/ranger.nvim
	-- Docs: https://github.com/francoiscabrol/ranger.vim
	--
	-- Add ranger integration.
	--
	{
		"francoiscabrol/ranger.vim",
		dependencies = { "rbgrouleff/bclose.vim" },

		lazy = false,
		priority = 0,

		init = function()
			vim.g.ranger_replace_netrw = 1
		end,
	},
}
