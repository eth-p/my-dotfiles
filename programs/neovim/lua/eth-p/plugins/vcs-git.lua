-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local opts = require("eth-p.opts")
return {

	-- gitsigns.nvim
	--
	-- Repo: https://github.com/lewis6991/gitsigns.nvim
	-- Docs: https://github.com/lewis6991/gitsigns.nvim
	--
	-- Display the keymaps.
	--
	{
		"lewis6991/gitsigns.nvim",
		version = "^0.9.0",

		event = "VeryLazy",
		lazy = true,

		opts = {},
	},
}
