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
		cond = opts.integration.git,

		event = "VeryLazy",
		lazy = true,

		opts = {},
	},

	-- blame.nvim
	--
	-- Repo: https://github.com/FabijanZulj/blame.nvim
	-- Docs: https://github.com/FabijanZulj/blame.nvim
	--
	-- Command to show a git blame.
	--
	{
		"FabijanZulj/blame.nvim",
		cond = opts.integration.git,

		lazy = true,
		cmd = {
			"BlameToggle",
		},
		keys = {
			{
				"<Leader>gb",
				"<Cmd>BlameToggle<CR>",
				desc = "Toggle git blame",
			},
		},

		opts = {
			focus_blame = false,
			mappings = {
				show_commit = "d",
				commit_info = { "<CR>", "i" },
			},
		},
	},
}
