-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
return {

	-- telescope
	--
	-- Repo: https://github.com/nvim-telescope/telescope.nvim
	-- Docs: https://github.com/nvim-telescope/telescope.nvim
	--
	-- TODO USAGE
	--
	{
		"nvim-telescope/telescope.nvim",
		version = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },

		lazy = "true",

		cmd = {
			"Telescope",
		},

		keys = {
			{
				"<C-W>a",
				"<Cmd>Telescope buffers<CR>",
				desc = "Switch active window buffer",
			},
			{
				"<Leader>tg",
				"<Cmd>Telescope live_grep<CR>",
				desc = "Grep through the working directory",
			},
			{
				"<Leader>tf",
				"<Cmd>Telescope find_files<CR>",
				desc = "Find files in the working directory",
			},
			{
				"<Leader>tr",
				"<Cmd>Telescope resume<CR>",
				desc = "Resume search",
			},
		},
	},
}
