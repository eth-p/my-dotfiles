-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local commands = require("eth-p.commands")
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
		version = "^1.0.0",
		cond = opts.integration.git,

		event = "VeryLazy",
		lazy = true,

		keys = {
			{
				"<Leader>gb",
				commands.GitBlame,
				desc = "Toggle git blame",
			},
		},

		opts = {},
	},
}
